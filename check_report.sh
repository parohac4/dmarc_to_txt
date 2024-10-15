#!/bin/bash

# Zadejte cestu k XML reportu
xml_file="dmarc_report.xml"
output_file="dmarc_report.txt"

# Funkce pro extrahování dat z XML pomocí xmllint
function extract_data {
    local xml_path=$1
    xmllint --xpath "$xml_path" "$xml_file" 2>/dev/null
}

# Funkce pro převod Unix timestampu na čitelné datum
function convert_timestamp {
    local timestamp=$1
    # Zjistit, na jakém systému se skript spouští
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - použití příkazu date s -d
        date -d @$timestamp +"%Y-%m-%d %H:%M:%S"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - použití příkazu date s -r
        date -r $timestamp +"%Y-%m-%d %H:%M:%S"
    else
        echo "Nepodporovaný operační systém"
    fi
}

# Otevřít výstupní soubor a přepsat do něj formátované údaje
echo "=== DMARC Report ===" > "$output_file"

# Extrakce důležitých informací
echo "Report Metadata:" >> "$output_file"
echo "=================" >> "$output_file"
echo "Org Name: $(extract_data '//report_metadata/org_name/text()')" >> "$output_file"
echo "Email: $(extract_data '//report_metadata/email/text()')" >> "$output_file"
echo "Report ID: $(extract_data '//report_metadata/report_id/text()')" >> "$output_file"

# Extrakce a převod timestampu na lidsky čitelné datum
begin_date=$(extract_data '//report_metadata/date_range/begin/text()')
end_date=$(extract_data '//report_metadata/date_range/end/text()')

echo "Date Range: $(convert_timestamp $begin_date) to $(convert_timestamp $end_date)" >> "$output_file"
echo "" >> "$output_file"

echo "=== Policy Information ===" >> "$output_file"
echo "==========================" >> "$output_file"
echo "Domain: $(extract_data '//policy_published/domain/text()')" >> "$output_file"
echo "Policy: $(extract_data '//policy_published/p/spf/text()')" >> "$output_file"
echo "DKIM Alignment: $(extract_data '//policy_published/adkim/text()')" >> "$output_file"
echo "SPF Alignment: $(extract_data '//policy_published/aspf/text()')" >> "$output_file"
echo "Disposition: $(extract_data '//policy_published/p/text()')" >> "$output_file"
echo "" >> "$output_file"

echo "=== Records ===" >> "$output_file"
echo "==============" >> "$output_file"
records_count=$(xmllint --xpath "count(//record)" "$xml_file")

for (( i=1; i<=records_count; i++ )); do
    echo "Record $i:" >> "$output_file"
    echo "Source IP: $(extract_data "(//record[$i]/row/source_ip)/text()")" >> "$output_file"
    echo "Count: $(extract_data "(//record[$i]/row/count)/text()")" >> "$output_file"
    echo "Disposition: $(extract_data "(//record[$i]/row/policy_evaluated/disposition)/text()")" >> "$output_file"
    echo "SPF Result: $(extract_data "(//record[$i]/row/policy_evaluated/spf)/text()")" >> "$output_file"
    echo "DKIM Result: $(extract_data "(//record[$i]/row/policy_evaluated/dkim)/text()")" >> "$output_file"
    echo "" >> "$output_file"
done

echo "DMARC Report was successfully converted to $output_file."

