# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "requests",
# ]
# ///
import requests
import os
import concurrent.futures
from datetime import datetime

class CloudflareDeploymentCleaner:
    def __init__(self, token, account_id, project_name):
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        self.account_id = account_id
        self.project_name = project_name
        self.base_url = f"https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}"

    def get_deployments(self, deployment_type):
        all_deployments = []
        current_page = 1

        while True:
            response = requests.get(
                f"{self.base_url}/deployments",
                headers=self.headers,
                params={"page": str(current_page), "env": deployment_type}
            )

            if response.status_code != 200:
                raise Exception(f"Failed to get deployments: {response.text}")

            data = response.json()
            all_deployments.extend(data["result"])

            result_info = data["result_info"]
            if current_page >= result_info["total_pages"]:
                break

            current_page += 1

        return all_deployments

    def get_deployment_info(self, deployment_id):
        response = requests.get(
            f"{self.base_url}/deployments/{deployment_id}",
            headers=self.headers,
        )

        if response.status_code != 200:
            raise Exception(f"Failed to get deployment {deployment_id}: {response.text}")

        return response.json()['result']


    def delete_deployment(self, deployment_id):
        response = requests.delete(f"{self.base_url}/deployments/{deployment_id}", headers=self.headers)
        return deployment_id, response.status_code == 200

    def get_prod_delete_list(self):
        # get production deployments
        prod_deployments = self.get_deployments("production")

        # sort from newest to oldest
        sorted_prod_deployments = sorted(
            prod_deployments,
            key=lambda x: datetime.fromisoformat(x['created_on'].replace('Z', '+00:00')),
            reverse=True
        )

        # keep newest (first index)
        deployments_to_delete = sorted_prod_deployments[1:]

        return deployments_to_delete

    def get_preview_delete_list(self):
        # get all preview deployments
        sub_deployments = self.get_deployments("preview")

        deployments_to_delete = []

        # delete all deployments without subdomain (i.e. not newest in branch)
        for deployment in sub_deployments:
            # query deployment data
            data = self.get_deployment_info(deployment['id'])
            # preview deployment have no subdomain if no aliases exists
            if data['aliases'] is None:
                deployments_to_delete.append(deployment)

        return deployments_to_delete


    def cleanup_old_deployments(self, production_only=False):

        # multithreading
        with concurrent.futures.ThreadPoolExecutor() as executor:

            print("determining deployments to delete...", flush=True)

            if production_only:
                queries = [executor.submit(self.get_prod_delete_list)]
            else:
                queries = [
                    executor.submit(self.get_prod_delete_list),
                    executor.submit(self.get_preview_delete_list)
                ]

            (lists, _) = concurrent.futures.wait(queries)

            deployments_to_delete = []
            for li in lists:
                deployments_to_delete.extend(li.result())

            print(f"selected {len(deployments_to_delete)} deployments for deletion!", flush=True)

            deletions = [
                executor.submit(self.delete_deployment, deployment['id']) for deployment in deployments_to_delete
            ]

            # iterator
            results = concurrent.futures.as_completed(deletions)

            for result in results:
                if not result.result():
                    print(f"failed to delete deployment {result.result()[0]}", flush=True)
                else:
                    print(f"deleted deployment {result.result()[0]}", flush=True)


# Usage
TOKEN = os.getenv("CLOUDFLARE_API_TOKEN")
ACCOUNT_ID = os.getenv("CLOUDFLARE_ACCOUNT_ID")
PROJECT_NAME = os.getenv("PROJECT_NAME")

cleaner = CloudflareDeploymentCleaner(TOKEN, ACCOUNT_ID, PROJECT_NAME)
cleaner.cleanup_old_deployments()
