#!/bin/bash

# ==============================================================================
# SCRIPT GENERADOR DE PROYECTOS (Versión con Plantillas .stencil)
#
# Requisitos:
#   - yq (para parsear YAML)
#   - tuist (para la gestión del proyecto)
#   - Un archivo 'structure.yml' en el mismo directorio.
#   - Una carpeta 'templates/' con las plantillas (.stencil) para cada 'type'.
# ==============================================================================

# --- Configuration ---
YAML_FILE="architecture.yml"
TEMPLATES_DIR="Templates"

# --- Colors for output ---
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Pre-flight Checks ---

# 1. Check if the script is being run by Bash
if [ -z "$BASH_VERSION" ]; then
    echo -e "${COLOR_RED}Error: Este script debe ser ejecutado con Bash, no con 'sh'.${NC}" >&2
    echo -e "${COLOR_YELLOW}Por favor, ejecútalo así: ./build.sh${NC}" >&2
    exit 1
fi

# 2. Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo -e "${COLOR_RED}Error: 'yq' no está instalado.${NC}"
    echo -e "${COLOR_YELLOW}Por favor, instálalo para continuar. Visita: https://github.com/mikefarah/yq#install${NC}"
    exit 1
fi

# 3. Check if tuist is installed
if ! command -v tuist &> /dev/null; then
    echo -e "${COLOR_RED}Error: 'tuist' no está instalado.${NC}"
    echo -e "${COLOR_YELLOW}Por favor, instálalo para continuar. Visita: https://tuist.io/docs/getting-started/installation/${NC}"
    exit 1
fi

# 4. Check if the YAML file exists
if [ ! -f "$YAML_FILE" ]; then
    echo -e "${COLOR_RED}Error: El archivo de configuración '$YAML_FILE' no fue encontrado.${NC}"
    exit 1
fi

# 5. Check if the templates directory exists
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo -e "${COLOR_RED}Error: El directorio de plantillas '$TEMPLATES_DIR' no fue encontrado.${NC}"
    exit 1
fi

# --- Main Logic ---

# Get project metadata
PROJECT_NAME=$(yq e '.name' "$YAML_FILE")
AUTHOR_NAME=$(yq e '.author' "$YAML_FILE")
CURRENT_DATE=$(date +'%Y/%m/%d')

echo -e "${COLOR_BLUE}🚀 Iniciando la generación del proyecto '$PROJECT_NAME'...${NC}"
echo "--------------------------------------------------"

# --- Confirmation Prompt ---
# Check if the project directory already exists
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${COLOR_YELLOW}Advertencia: El directorio '$PROJECT_NAME' ya existe.${NC}"
    echo -e "${COLOR_YELLOW}Si continúas, los archivos existentes podrían ser sobrescritos.${NC}"
    read -p "¿Deseas continuar? (y/N) " -n 1 -r
    echo # Mueve el cursor a una nueva línea
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${COLOR_BLUE}Operación cancelada por el usuario.${NC}"
        exit 0
    fi
fi

# 1. Create the root project folder
echo -e "  ${COLOR_GREEN}Creando directorio raíz del proyecto:${NC} $PROJECT_NAME"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 2. Parse YAML and create files from templates (Método compatible)
# Create a temporary file to store the parsed data
temp_file=$(mktemp)

# Execute yq and save the output to the temp file
# The yq query gets [directory_path, filename, type] for each file entry
yq e ".build | .. | select(has(\"file\")) | [(path | .[1:] | join(\"/\")), .file, .type] | @tsv" "../$YAML_FILE" > "$temp_file"

# Check if yq command produced any output
if [ ! -s "$temp_file" ]; then
    echo -e "${COLOR_YELLOW}No se encontraron archivos para generar en '$YAML_FILE'.${NC}"
    rm -f "$temp_file" # Clean up
    exit 0
fi

# Read from the temporary file line by line
while IFS=$'\t' read -r dir_path file_name file_type; do
    # Skip empty lines that might result from yq
    if [ -z "$file_name" ]; then
        continue
    fi

    # Construct the full path for the new file
    full_dir_path="$dir_path"
    full_file_path="$full_dir_path/$file_name"

    # Create the directory
    echo -e "  ${COLOR_GREEN}Creando directorio:${NC} $full_dir_path"
    mkdir -p "$full_dir_path"

    # Define the path to the template file
    # --- CAMBIO AQUÍ: ahora busca la extensión .stencil ---
    template_file="../$TEMPLATES_DIR/$file_type.stencil"

    # Create the file from the template
    if [ -f "$template_file" ]; then
        echo -e "  ${COLOR_BLUE}Creando archivo desde plantilla ($file_type):${NC} $full_file_path"
        
        # El comando sed sigue funcionando porque solo reemplaza texto,
        # no le importa la extensión del archivo.
        sed -e "s#{{FILENAME}}#${file_name%.*}#g" \
            -e "s#{{PROJECT_NAME}}#${PROJECT_NAME}#g" \
            -e "s#{{AUTHOR}}#${AUTHOR_NAME}#g" \
            -e "s#{{DATE}}#${CURRENT_DATE}#g" \
            "$template_file" > "$full_file_path"
    else
        echo -e "  ${COLOR_YELLOW}Creando archivo vacío (plantilla '$file_type' no encontrada):${NC} $full_file_path"
        touch "$full_file_path"
    fi
done < "$temp_file"

# Clean up the temporary file
rm -f "$temp_file"

echo "--------------------------------------------------"
echo -e "${COLOR_GREEN}✅ ¡Proyecto '$PROJECT_NAME' generado exitosamente!${NC}"
