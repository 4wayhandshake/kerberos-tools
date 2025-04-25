#!/bin/bash

# Default value for output file
output_file="custom_krb5.conf"
kdc_fqdn=""

# Function to print usage
print_usage() {
  echo "Usage: $0 [options]"
  echo "  -K, --kdc-fqdn       <FQDN>         (Required) FQDN for the KDC, ex dc01.whatever.lol"
  echo "  -o, --output-file    <output file>  (Optional) Filepath for output (default: custom_krb5.config)"
  exit 1
}

# Loop through arguments manually
while [[ $# -gt 0 ]]; do
  case "$1" in
    -K|--kdc-fqdn)
      if [[ -n "$2" ]] && [[ ${2:0:1} != "-" ]]; then
        kdc_fqdn="$2"
        shift 2
      else
        echo "Error: Missing argument for $1"
        print_usage
      fi
      ;;
    -o|--output-file)
      if [[ -n "$2" ]] && [[ ${2:0:1} != "-" ]]; then
        output_file="$2"
        shift 2
      else
        echo "Error: Missing argument for $1"
        print_usage
      fi
      ;;
    -*)
      echo "Unknown option: $1"
      print_usage
      ;;
    *)
      # This would be for non-option arguments, if needed
      echo "Unknown argument: $1"
      print_usage
      ;;
  esac
done

# Check if required parameter kdc_fqdn is provided.
if [[ -z "$kdc_fqdn" ]]; then
  echo "Error: The -K/--kdc-fqdn parameter is required."
  print_usage
fi

DC_HOSTNAME="${kdc_fqdn%%.*}"
REALM="${kdc_fqdn#*.}"
LOWER_REALM=$(echo "$REALM" | tr '[:upper:]' '[:lower:]')
UPPER_REALM=$(echo "$REALM" | tr '[:lower:]' '[:upper:]')

config_template=$(cat<<EOF
[libdefaults]
    default_realm = {{REALM_PLACEHOLDER}}
    dns_lookup_realm = true
    dns_lookup_kdc = true

[realms]
    {{REALM_PLACEHOLDER}} = {
        kdc = {{dc_hostname}}.{{realm_placeholder}}
        admin_server = {{dc_hostname}}.{{realm_placeholder}}
        default_domain = {{dc_hostname}}.{{realm_placeholder}}
    }

[domain_realm]
    {{realm_placeholder}} = {{REALM_PLACEHOLDER}}
    .{{realm_placeholder}} = {{REALM_PLACEHOLDER}}
EOF
)

echo -e "\nWriting config file to: $output_file\n"
echo "$config_template" | sed \
-e "s/{{REALM_PLACEHOLDER}}/$UPPER_REALM/g" \
-e "s/{{realm_placeholder}}/$LOWER_REALM/g" \
-e "s/{{dc_hostname}}/$DC_HOSTNAME/g" | tee "$output_file"
