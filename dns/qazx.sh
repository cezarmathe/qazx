#!/usr/bin/env bash

# This script will attempt to find the public ip of this machine, set the corresponding variable
# in a tfvars file and then apply a Terraform plan to update a specific DNS record.

CLOUDFLARE_API_ENDPOINT="https://api.cloudflare.com/client/v4/zones"

# Import the zone in the current Terraform state.
function import_zone() {
    local cloudflare_api_token
    cloudflare_api_token="$(cat main.auto.tfvars | grep cloudflare_api_token | tr -s ' ' | cut -d ' ' -f 3)"
    cloudflare_api_token="${cloudflare_api_token%\"}"
    cloudflare_api_token="${cloudflare_api_token#\"}"

    local cloudflare_zone
    cloudflare_zone="$(cat main.auto.tfvars | grep cloudflare_zone_main | tr -s ' ' | cut -d ' ' -f 3)"
    cloudflare_zone="${cloudflare_zone%\"}"
    cloudflare_zone="${cloudflare_zone#\"}"

    local response
    response="$(curl -X GET "${CLOUDFLARE_API_ENDPOINT}?name=${cloudflare_zone}&status=active" \
        -H "Authorization: Bearer ${cloudflare_api_token}" \
        -H "Content-Type: application/json")"

    local success
    success="$(printf "%s" "${response}" | jq .success )"
    if [[ "${success}" != "true" ]]; then
        printf "%s\n" "Failed to get the zone id."
        printf "%s\n" "Response: ${response}"
        exit 1
    fi

    local zone_id
    zone_id="$(printf "%s" "${response}" | jq .result[0].id )"
    zone_id="${zone_id%\"}"
    zone_id="${zone_id#\"}"

    terraform import -input=false cloudflare_zone.main ${zone_id}
}

function find_public_ip() {
    local public_ip
    public_ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
    if [[ "$?" != "0" ]]; then
        printf "%s\n" "Failed to get public ip."
        printf "%s\n" "$(public_ip)"
        exit 1
    fi
    printf "%s\n" "qazx_ip_addr = \"${public_ip}\"" > qazx.auto.tfvars
}

# Update the desired DNS record.
function update_record() {
    printf "%s\n" "Finding public ip.."
    find_public_ip

    printf "%s\n" "Applying the Terraform plan.."
    terraform apply -auto-approve -input=false

    if [[ "$?" != "0" ]]; then
        printf "%s\n" "Terraform failed to apply the plan."
        printf "%s\n" "Removing qazx.tfvars.."
        rm qazx.auto.tfvars
        exit 0
    fi

    printf "%s\n" "Removing qazx.tfvars.."
    rm qazx.auto.tfvars

    printf "%s\n" "Done!"
}

function main() {
    printf "%s\n" "Reinitializing Terraform.."
    terraform init

    case "${QAZX_CMD}" in
    "update_record")
        update_record
        ;;
    "import_zone")
        import_zone
        ;;
    *)
        printf "%s\n" "Unknown command."
        exit 1
        ;;
    esac
}

main $@
