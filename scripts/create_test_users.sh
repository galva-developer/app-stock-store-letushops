#!/bin/bash

# Script para crear usuarios de prueba en Firebase Authentication
# Uso: ./scripts/create_test_users.sh

echo "🔐 Creando usuarios de prueba para Stock LetuShops..."
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar si Firebase CLI está instalado
if ! command -v firebase &> /dev/null
then
    echo "${YELLOW}⚠️  Firebase CLI no está instalado${NC}"
    echo "Instálalo con: npm install -g firebase-tools"
    exit 1
fi

echo "📝 Este script creará los siguientes usuarios:"
echo ""
echo "1. Administrador Principal"
echo "   Email: admin@letushops.com"
echo "   Password: Admin123456"
echo ""
echo "2. Usuario de Prueba"
echo "   Email: test@letushops.com"
echo "   Password: Test123456"
echo ""
echo "3. Usuario Demo"
echo "   Email: demo@letushops.com"
echo "   Password: Demo123456"
echo ""

read -p "¿Deseas continuar? (s/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]
then
    echo "❌ Cancelado"
    exit 1
fi

echo ""
echo "⚠️  IMPORTANTE:"
echo "Este script requiere que uses Firebase Admin SDK o la consola de Firebase."
echo "Por razones de seguridad, no se puede crear usuarios desde scripts de shell directamente."
echo ""
echo "📋 Opciones para crear usuarios:"
echo ""
echo "Opción 1: Usar Firebase Console"
echo "  1. Ve a https://console.firebase.google.com/"
echo "  2. Selecciona tu proyecto"
echo "  3. Ve a Authentication > Users"
echo "  4. Haz clic en 'Add user'"
echo "  5. Ingresa email y password"
echo ""
echo "Opción 2: Usar la aplicación"
echo "  1. Ejecuta: flutter run"
echo "  2. En la pantalla de Login, haz clic en 'Crear cuenta'"
echo "  3. Registra tu usuario"
echo ""
echo "Opción 3: Usar Firebase Auth REST API"
echo "  Ejecuta el siguiente comando (requiere tu API Key):"
echo ""
echo "  curl -X POST 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=YOUR_API_KEY' \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  --data-binary '{\"email\":\"admin@letushops.com\",\"password\":\"Admin123456\",\"returnSecureToken\":true}'"
echo ""
echo "${GREEN}✅ Consulta ACCESS_GUIDE.md para más información${NC}"
