PROJECT_ID=$(shell gcloud config get-value core/project)
all:
	@echo "build  - Build the docker image"
	@echo "deploy - Deploy the image to Cloud Run"
	@echo "clean  - Clean resoruces created in this test"
	@echo "call   - Call the Cloud Run service"

build:
	gcloud builds submit --tag gcr.io/$(PROJECT_ID)/test-ip

deploy:
	gcloud beta run deploy test-ip \
		--image gcr.io/$(PROJECT_ID)/test-ip \
		--max-instances 1 \
		--platform managed \
		--region us-central1 \
		--no-allow-unauthenticated \
		--vpc-connector projects/$(PROJECT_ID)/locations/us-central1/connectors/vpc-sconn-default \
		--vpc-egress all

clean:
	-gcloud container images delete gcr.io/$(PROJECT_ID)/test-ip --quiet
	-gcloud run services delete test-ip \
		--platform managed \
		--region us-central1 \
		--quiet

call:
	@echo "Calling Node-JS Cloud Run service"
	@url=$(shell gcloud run services describe test-ip --format='value(status.url)' --region us-central1 --platform managed); \
	token=$(shell gcloud auth print-identity-token); \
	curl --request POST \
  		--header "Authorization: Bearer $$token" \
  		--header "Content-Type: text/plain" \
		$$url/exec \
  		--data-binary "printenv"