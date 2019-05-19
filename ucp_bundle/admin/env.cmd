@echo off
set DOCKER_TLS_VERIFY=1
set COMPOSE_TLS_VERSION=TLSv1_2
set DOCKER_CERT_PATH=%~dp0
set DOCKER_HOST=tcp://ucp.docker.ee:443

kubectl >nul 2>&1
if %ERRORLEVEL% == 0 (
    set KUBECONFIG=
    kubectl config set-cluster ucp_ucp.docker.ee:6443_admin --server https://ucp.docker.ee:6443 --certificate-authority "%~dp0ca.pem" --embed-certs
    kubectl config set-credentials ucp_ucp.docker.ee:6443_admin --client-key "%~dp0key.pem" --client-certificate "%~dp0cert.pem" --embed-certs
    kubectl config set-context ucp_ucp.docker.ee:6443_admin --user ucp_ucp.docker.ee:6443_admin --cluster ucp_ucp.docker.ee:6443_admin
)
set KUBECONFIG=%~dp0kube.yml

REM
REM Bundle for user admin
REM UCP Instance ID ox51ffj80pxj2oe5xglu8m482
REM
REM This admin cert will also work directly against Swarm and the individual
REM engine proxies for troubleshooting.  After sourcing this env file, use
REM "docker info" to discover the location of Swarm managers and engines.
REM and use the --host option to override $DOCKER_HOST
REM
REM Run this command from within this directory to configure your shell:
REM .\env.cmd
