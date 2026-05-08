# ⚙️ Backend - MediCost-AI

## 📌 Descripción

El backend de **MediCost-AI** está desarrollado con FastAPI y es responsable de toda la lógica del sistema.

Se encarga de:

- Procesar las solicitudes del usuario
- Interpretar síntomas (IA o reglas)
- Calcular el copago estimado
- Consultar datos desde Supabase
- Comparar hospitales
- Generar la respuesta final

---

## 🛠️ Tecnologías

- FastAPI
- Python
- Supabase (cliente para conexión a BD)
- Google Gemini (IA - opcional en fases avanzadas)

---

## 📂 Estructura del proyecto

```text
backend/
├── app/
│   ├── main.py                 # Punto de entrada
│   ├── api/
│   │   └── routes/
│   │       └── chat.py         # Endpoint principal
│   ├── services/
│   │   ├── symptom_service.py
│   │   ├── coverage_service.py
│   │   ├── copay_service.py
│   │   └── hospital_service.py
│   ├── agents/
│   │   └── medical_agent.py    # Integración con IA
│   ├── models/                 # Modelos de datos
│   └── utils/                  # Funciones auxiliares
├── requirements.txt
└── Dockerfile
```

---

## ⚙️ Instalación y ejecución

1. Crear entorno virtual (opcional, pero recomendado):

```bash
python -m venv venv
```

2. Activar entorno virtual:

```bash
# Linux/macOS
source venv/bin/activate

# Windows (PowerShell)
venv\Scripts\Activate.ps1

# Windows (CMD)
venv\Scripts\activate
```

3. Instalar dependencias:

```bash
pip install -r requirements.txt
```

4. Ejecutar servidor:

```bash
uvicorn app.main:app --reload
```

Servidor disponible en:

http://localhost:8000

---

## 🔌 Endpoint principal

`POST /chat`

Procesa el mensaje del usuario y devuelve la estimación completa.

**Request**

```json
{
  "user_id": 1,
  "message": "dolor en el pecho"
}
```

**Response**

```json
{
  "specialty": "Cardiología",
  "coverage": 0.8,
  "copay": 16,
  "hospitals": [
    { "name": "Hospital A", "copay": 16 },
    { "name": "Hospital B", "copay": 14 }
  ],
  "recommendation": "Hospital B"
}
```

---

## 🧠 Flujo interno

Mensaje del usuario
	↓
chat.py (endpoint)
	↓
agent_service
	↓
symptom_service → especialidad
	↓
coverage_service → cobertura
	↓
copay_service → cálculo
	↓
hospital_service → ranking
	↓
respuesta final

---

## 🧮 Lógica de negocio

Cálculo de copago:

```text
copago = costo_servicio * (1 - cobertura)
```

---

## 🔗 Integración con Supabase

El backend consulta Supabase para obtener:

- Plan del usuario
- Cobertura
- Servicios médicos
- Costos
- Hospitales disponibles

Se recomienda usar variables de entorno:

```env
SUPABASE_URL=your_url
SUPABASE_KEY=your_key
```

---

## 🤖 Inteligencia Artificial

Se utiliza IA para:

- Interpretar síntomas
- Clasificar especialidad médica

Ejemplo:

- Input: "dolor en la rodilla"
- Output: Traumatología

⚠️ En el MVP se puede usar lógica basada en reglas.

---

## 🎯 Responsabilidades del backend

- Procesamiento de datos
- Lógica de negocio
- Integración con IA
- Comunicación con la base de datos
- Generación de respuestas

---

## 🚀 Mejoras futuras

- Caché de respuestas
- Validaciones avanzadas
- Manejo de errores robusto
- Optimización de consultas
- Integración con APIs externas

---

## 🧪 Notas

- El backend no maneja autenticación directamente (lo hace Supabase).
- Se recomienda separar lógica en servicios para mantener escalabilidad.

---

## 📦 Docker (opcional)

```bash
docker build -t medicost-backend .
docker run -p 8000:8000 medicost-backend
```

---

## 📌 Conclusión

El backend de MediCost-AI centraliza la inteligencia del sistema, permitiendo procesar síntomas, calcular costos y generar recomendaciones médicas de forma eficiente, apoyándose en Supabase para la gestión de datos y en IA para mejorar la precisión del análisis.

---

Si quieres, el siguiente paso puede ser el README de `database/` o `docs/`, o directamente el código base del endpoint funcionando.

