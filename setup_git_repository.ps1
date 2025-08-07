# ============================================================================
# Script de Configuración Completa para Repositorio Git + GitHub
# Automatiza todo el proceso de creación y configuración de repositorio
# ============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = (Get-Location).Path,
    
    [Parameter(Mandatory=$false)]
    [string]$GitUserName = "Tu Nombre",
    
    [Parameter(Mandatory=$false)]
    [string]$GitUserEmail = "tu-email@ejemplo.com"
)

Write-Host "🚀 Iniciando configuración de repositorio Git + GitHub..." -ForegroundColor Green
Write-Host "📂 Directorio del proyecto: $ProjectPath" -ForegroundColor Cyan
Write-Host "📦 Nombre del repositorio: $RepoName" -ForegroundColor Cyan
Write-Host "👤 Usuario de GitHub: $GitHubUsername" -ForegroundColor Cyan

# Función para verificar si un comando existe
function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    }
    catch {
        return $false
    }
}

# Verificar prerequisitos
Write-Host "`n🔍 Verificando prerequisitos..." -ForegroundColor Yellow

if (-not (Test-Command "git")) {
    Write-Host "❌ Git no está instalado. Instala Git desde: https://git-scm.com/" -ForegroundColor Red
    exit 1
}

if (-not (Test-Command "gh")) {
    Write-Host "⚠️  GitHub CLI no está instalado. Instala desde: https://cli.github.com/" -ForegroundColor Yellow
    Write-Host "   O crea el repositorio manualmente en GitHub" -ForegroundColor Yellow
    $useGitHubCLI = $false
} else {
    $useGitHubCLI = $true
}

# Cambiar al directorio del proyecto
Set-Location $ProjectPath

# Configurar Git globalmente
Write-Host "`n⚙️  Configurando Git..." -ForegroundColor Yellow
git config --global user.name "$GitUserName"
git config --global user.email "$GitUserEmail"
git config --global init.defaultBranch main

# Inicializar repositorio Git si no existe
if (-not (Test-Path ".git")) {
    Write-Host "📁 Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
} else {
    Write-Host "✅ Repositorio Git ya existe" -ForegroundColor Green
}

# Crear .gitignore si no existe
if (-not (Test-Path ".gitignore")) {
    Write-Host "📝 Creando .gitignore..." -ForegroundColor Yellow
    @"
# Python
__pycache__/
*.py[cod]
*${'$'}py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
*.log
logs/

# Dependencies
node_modules/
package-lock.json
yarn.lock

# Temporary files
*.tmp
*.temp
temp/
tmp/

# Project specific
config.local.json
.env.local
.env.production
secrets/
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
}

# Crear README.md si no existe
if (-not (Test-Path "README.md")) {
    Write-Host "📖 Creando README.md..." -ForegroundColor Yellow
    @"
# $RepoName

Descripción del proyecto aquí.

## 🚀 Inicio Rápido

\`\`\`bash
# Clonar el repositorio
git clone https://github.com/$GitHubUsername/$RepoName.git
cd $RepoName

# Instalar dependencias (si aplica)
# pip install -r requirements.txt
# npm install

# Ejecutar el proyecto
# python main.py
# npm start
\`\`\`

## 📋 Características

- Característica 1
- Característica 2
- Característica 3

## 🛠️ Tecnologías

- Python
- HTML/CSS/JavaScript
- Otras tecnologías...

## 🤝 Contribuir

1. Fork el proyecto
2. Crear branch para feature (\`git checkout -b feature/AmazingFeature\`)
3. Commit los cambios (\`git commit -m 'feat: Add some AmazingFeature'\`)
4. Push al branch (\`git push origin feature/AmazingFeature\`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está licenciado bajo la MIT License.
"@ | Out-File -FilePath "README.md" -Encoding UTF8
}

# Agregar archivos al staging area
Write-Host "`n📦 Agregando archivos al repositorio..." -ForegroundColor Yellow
git add .

# Verificar estado
Write-Host "`n📊 Estado del repositorio:" -ForegroundColor Yellow
git status

# Hacer commit inicial si hay cambios
$hasChanges = git status --porcelain
if ($hasChanges) {
    Write-Host "`n💾 Realizando commit inicial..." -ForegroundColor Yellow
    git commit -m "feat: initial commit

- Add project structure and configuration
- Create comprehensive documentation
- Establish development workflow
- Configure Git repository with best practices"
} else {
    Write-Host "✅ No hay cambios para commitear" -ForegroundColor Green
}

# Crear repositorio en GitHub usando CLI
if ($useGitHubCLI) {
    Write-Host "`n🌐 Creando repositorio en GitHub..." -ForegroundColor Yellow
    
    # Verificar autenticación
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "🔐 Necesitas autenticarte en GitHub CLI:" -ForegroundColor Yellow
        Write-Host "   Ejecuta: gh auth login" -ForegroundColor Cyan
        Write-Host "   Luego vuelve a ejecutar este script" -ForegroundColor Cyan
        exit 1
    }
    
    # Crear repositorio
    try {
        gh repo create $RepoName --public --source=. --remote=origin --push
        Write-Host "✅ Repositorio creado exitosamente en GitHub!" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  Error creando repositorio con GitHub CLI. Creando remoto manualmente..." -ForegroundColor Yellow
        $manualSetup = $true
    }
}

# Configuración manual si GitHub CLI no está disponible o falla
if (-not $useGitHubCLI -or $manualSetup) {
    Write-Host "`n🔧 Configuración manual del repositorio remoto:" -ForegroundColor Yellow
    Write-Host "1. Ve a https://github.com/new" -ForegroundColor Cyan
    Write-Host "2. Crea un repositorio llamado: $RepoName" -ForegroundColor Cyan
    Write-Host "3. NO inicialices con README, .gitignore o licencia" -ForegroundColor Cyan
    Write-Host "4. Después de crear, ejecuta estos comandos:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   git remote add origin https://github.com/$GitHubUsername/$RepoName.git" -ForegroundColor White
    Write-Host "   git branch -M main" -ForegroundColor White
    Write-Host "   git push -u origin main" -ForegroundColor White
    Write-Host ""
    
    # Configurar remoto automáticamente
    $remoteUrl = "https://github.com/$GitHubUsername/$RepoName.git"
    
    # Verificar si ya existe el remoto
    $existingRemote = git remote get-url origin 2>$null
    if ($existingRemote) {
        Write-Host "🔄 Actualizando URL del remoto existente..." -ForegroundColor Yellow
        git remote set-url origin $remoteUrl
    } else {
        Write-Host "🔗 Agregando remoto origin..." -ForegroundColor Yellow
        git remote add origin $remoteUrl
    }
    
    # Cambiar a branch main
    git branch -M main
    
    Write-Host "`n⏸️  Script pausado. Después de crear el repositorio en GitHub, presiona Enter para continuar..." -ForegroundColor Yellow
    Read-Host
    
    # Intentar push
    Write-Host "🚀 Realizando push al repositorio remoto..." -ForegroundColor Yellow
    try {
        git push -u origin main
        Write-Host "✅ Push exitoso!" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error en push. Verifica que el repositorio existe en GitHub" -ForegroundColor Red
        Write-Host "   URL esperada: https://github.com/$GitHubUsername/$RepoName" -ForegroundColor Cyan
    }
}

# Mostrar información final
Write-Host "`n🎉 ¡Configuración completada!" -ForegroundColor Green
Write-Host "📍 Ubicación del repositorio local: $ProjectPath" -ForegroundColor Cyan
Write-Host "🌐 URL del repositorio: https://github.com/$GitHubUsername/$RepoName" -ForegroundColor Cyan
Write-Host "🔗 Para clonar: git clone https://github.com/$GitHubUsername/$RepoName.git" -ForegroundColor Cyan

Write-Host "`n📋 Próximos pasos para el equipo:" -ForegroundColor Yellow
Write-Host "1. Compartir URL del repositorio con el equipo" -ForegroundColor White
Write-Host "2. Configurar branch protection rules si es necesario" -ForegroundColor White
Write-Host "3. Invitar colaboradores al repositorio" -ForegroundColor White
Write-Host "4. Configurar GitHub Pages si es una web estática" -ForegroundColor White

Write-Host "`n🔄 Workflow diario recomendado:" -ForegroundColor Yellow
Write-Host "git pull origin main" -ForegroundColor White
Write-Host "git checkout -b feature/nueva-funcionalidad" -ForegroundColor White
Write-Host "# ... hacer cambios ..." -ForegroundColor Gray
Write-Host "git add ." -ForegroundColor White
Write-Host "git commit -m 'feat: descripción del cambio'" -ForegroundColor White
Write-Host "git push origin feature/nueva-funcionalidad" -ForegroundColor White
Write-Host "# ... crear Pull Request en GitHub ..." -ForegroundColor Gray

Write-Host "`n✨ ¡Repositorio listo para colaboración en equipo!" -ForegroundColor Green
