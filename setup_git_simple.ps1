# Script simplificado de configuración Git
param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,

    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,

    [Parameter(Mandatory=$false)]
    [string]$GitUserName = "Tu Nombre",

    [Parameter(Mandatory=$false)]
    [string]$GitUserEmail = "tu-email@ejemplo.com"
)

Write-Host "Iniciando configuración de repositorio Git + GitHub..." -ForegroundColor Green
Write-Host "Repositorio: $RepoName" -ForegroundColor Cyan
Write-Host "Usuario GitHub: $GitHubUsername" -ForegroundColor Cyan

# Configurar Git
Write-Host "Configurando Git..." -ForegroundColor Yellow
git config --global user.name "$GitUserName"
git config --global user.email "$GitUserEmail"
git config --global init.defaultBranch main

# Inicializar repositorio
if (-not (Test-Path ".git")) {
    Write-Host "Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
}

# Crear .gitignore básico
if (-not (Test-Path ".gitignore")) {
    Write-Host "Creando .gitignore..." -ForegroundColor Yellow
    @"
# Flutter/Dart
.dart_tool/
.packages
build/
.flutter-plugins
.flutter-plugins-dependencies

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
}

# Crear README básico
if (-not (Test-Path "README.md")) {
    Write-Host "Creando README.md..." -ForegroundColor Yellow
    @"
# $RepoName

Descripcion del proyecto Musical IA.

## Inicio Rapido

1. Clonar el repositorio
2. Instalar dependencias
3. Ejecutar la aplicacion

## Tecnologias

- Flutter
- Dart
- AI/ML

## Licencia

MIT License
"@ | Out-File -FilePath "README.md" -Encoding UTF8
}

# Agregar archivos
Write-Host "Agregando archivos..." -ForegroundColor Yellow
git add .

# Commit inicial
$hasChanges = git status --porcelain
if ($hasChanges) {
    Write-Host "Realizando commit inicial..." -ForegroundColor Yellow
    git commit -m "feat: initial commit - Musical IA project setup"
}

# Configurar remoto
$remoteUrl = "https://github.com/$GitHubUsername/$RepoName.git"
Write-Host "Configurando remoto: $remoteUrl" -ForegroundColor Yellow

try {
    git remote add origin $remoteUrl
} catch {
    git remote set-url origin $remoteUrl
}

git branch -M main

Write-Host ""
Write-Host "IMPORTANTE: Debes crear el repositorio en GitHub manualmente:" -ForegroundColor Red
Write-Host "1. Ve a https://github.com/new" -ForegroundColor Cyan
Write-Host "2. Crea un repositorio llamado: $RepoName" -ForegroundColor Cyan
Write-Host "3. NO inicialices con README o .gitignore" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Enter después de crear el repositorio..." -ForegroundColor Yellow
Read-Host

# Push al repositorio
Write-Host "Realizando push..." -ForegroundColor Yellow
try {
    git push -u origin main
    Write-Host "¡Repositorio configurado exitosamente!" -ForegroundColor Green
    Write-Host "URL: https://github.com/$GitHubUsername/$RepoName" -ForegroundColor Cyan
} catch {
    Write-Host "Error en push. Verifica que el repositorio existe en GitHub" -ForegroundColor Red
}
