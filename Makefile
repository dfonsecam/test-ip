url=$(shell gcloud run services describe test-ip --format='value(status.url)' --region us-central1 --platform managed)
uid=$(shell gcloud auth print-identity-token)
pid=$(shell gcloud config get-value core/project)

cmd="telnet monibytebb 80"

all:
	@echo "build  - Build the docker image"
	@echo "deploy - Deploy the image to Cloud Run"
	@echo "clean  - Clean resoruces created in this test"
	@echo "call   - Call the Cloud Run service"

build:
	gcloud builds submit

clean:
	-gcloud container images delete gcr.io/$(pid)/test-ip --quiet
	-gcloud run services delete test-ip \
		--platform managed \
		--region us-central1 \
		--quiet

call-nat:
	@echo "Calling Node-JS Cloud Run service"
	@token=$(uid) url=$(url); \
	curl $$url \
		--request GET \
		--header "Authorization: Bearer $$token" \

call-cmd:
	@echo "Executing $(cmd)"
	@token=$(uid) url=$(url)/exec cmd=$(cmd); \
	curl $$url \
		--request POST \
  		--header "Authorization: Bearer $$token" \
  		--header "Content-Type: text/plain" \
  		--data-binary "$$cmd"