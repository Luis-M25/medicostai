# 🎨 Frontend - MediCost-AI

## 📌 Descripción

El frontend de **MediCost-AI** es la interfaz web donde el usuario interactúa con el sistema mediante un chat inteligente.

Permite al usuario:

- Ingresar síntomas en lenguaje natural
- Recibir una especialidad médica recomendada
- Consultar la cobertura de su seguro
- Visualizar el copago estimado
- Comparar hospitales disponibles
- Obtener una recomendación final

---

## 🛠️ Tecnologías

- Next.js
- TypeScript
- TailwindCSS

---

## 📂 Estructura del proyecto

frontend/
├── app/        # Rutas y páginas (Next.js App Router)
├── components/ # Componentes reutilizables
│   ├── Chat/
│   ├── Results/
│   └── UI/
├── services/   # Conexión con APIs
├── hooks/      # Custom hooks
├── types/      # Tipos TypeScript
└── utils/      # Funciones auxiliares

---

## ⚙️ Instalación y ejecución

1. Instalar dependencias:

```bash
cd frontend
npm install
```

2. Ejecutar en desarrollo:

```bash
npm run dev
```

3. Abrir en el navegador:

http://localhost:3000

---

## 🔌 Integración con Backend

El frontend se comunica con el backend mediante el endpoint `POST /chat`.

Ejemplo de request:

```json
{
  "user_id": 1,
  "message": "dolor en el pecho"
}
```

---

## 🧠 Funcionalidades principales

- Interfaz tipo chat
- Envío de mensajes al backend
- Renderizado de respuestas
- Visualización de resultados (copago, hospitales, recomendación)
- Manejo de estado de conversación

---

## 🎯 Flujo de uso

Usuario escribe síntoma
	↓
Se envía al backend
	↓
Se recibe respuesta
	↓
Se muestra:
  - Especialidad
  - Copago
  - Hospitales
  - Recomendación

---

## 🚀 Mejoras futuras

- Diseño UI/UX más avanzado
- Soporte para voz (speech-to-text)
- Animaciones e interacción mejorada
- Historial de conversaciones
- Modo oscuro

---

## 🧪 Notas

- El frontend depende del backend para la lógica de negocio.
- Mantener la URL del API en variables de entorno.

Ejemplo `.env.local`:

```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

---

## 📦 Build para producción

```bash
npm run build
npm start
```

---

## 📌 Conclusión

El frontend de MediCost-AI proporciona una experiencia simple e intuitiva para que el usuario pueda entender su cobertura médica y costos antes de acudir a un hospital, integrando una interfaz moderna con un sistema inteligente de backend.

---

Si quieres, puedo agregar ahora el código base del chat (React + llamada al API) listo para copiar.

