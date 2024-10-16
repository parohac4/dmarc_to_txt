
# DMARC XML do TXT Konvertor

Tento jednoduchý bash skript převádí DMARC XML report do čitelnějšího TXT formátu.

## Funkce
- Extrahuje důležité informace, jako je metadata reportu, informace o politice a jednotlivé záznamy.
- Převádí Unix timestampy na čitelný formát data a času.
- Používá `xmllint` k analýze XML dat.
- Ukládá data do formátovaného a přehledného textového souboru.

## Požadavky
Ujistěte se, že máte nainstalovaný `xmllint`. Pokud ne, můžete ho nainstalovat pomocí příkazu:

```bash
sudo apt-get install libxml2-utils
```

## Použití

1. Stáhněte nebo naklonujte tento repozitář.
2. Umístěte svůj DMARC XML report do stejného adresáře jako skript, nebo specifikujte cestu k souboru.
3. Udělejte skript spustitelným:

```bash
chmod +x convert_dmarc.sh
```

4. Spusťte skript:

```bash
./convert_dmarc.sh
```

Skript standardně zpracuje soubor pojmenovaný `dmarc_report.xml`. Cestu k souboru můžete změnit úpravou proměnné `xml_file` ve skriptu.

## Kompatibilita

Skript detekuje operační systém a podle toho použije správný příkaz pro převod Unix timestampů:
- **Linux**: Používá `date -d` pro převod timestampů.
- **macOS**: Používá `date -r` pro převod timestampů.

## Výstup

Skript vytvoří formátovaný textový soubor (`dmarc_report.txt`) s extrahovanými informacemi z DMARC reportu.

## Příklad

```bash
./convert_dmarc.sh
```

Ukázka výstupu:

```
=== DMARC Report ===
Metadata reportu:
=================
Org Name: Example Organization
Email: dmarc@example.com
Report ID: 123456789
Date Range: 2024-06-14 00:00:00 to 2024-06-14 23:59:59

=== Informace o politice ===
===========================
Domain: example.com
Policy: none
DKIM Alignment: relaxed
SPF Alignment: strict
Disposition: none

=== Záznamy ===
==============
Záznam 1:
Source IP: 192.0.2.1
Count: 100
Disposition: none
SPF Výsledek: pass
DKIM Výsledek: pass
...
```

## Licence
Tento projekt je licencován pod licencí MIT.
