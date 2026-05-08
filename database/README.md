# Base de datos - MediCost-AI

## Descripcion

La base de datos usa Supabase (PostgreSQL) y centraliza la logica de cobertura, costos y recomendacion de hospitales.

## Tablas principales

- `usuarios`
- `planes`
- `especialidades`
- `servicios`
- `hospitales`
- `reglas_cobertura`
- `servicios_hospital`
- `historial_chat`

## Orden de ejecucion

1. Ejecutar `schema.sql`.
2. Ejecutar `seed.sql`.
3. Probar las consultas clave de backend.

## Consultas clave para backend (William)

### 1) Obtener plan de un usuario

```sql
select u.id, u.nombre, u.email, p.id as plan_id, p.nombre as plan_nombre
from usuarios u
join planes p on p.id = u.plan_id
where u.email = 'anthony@medicost.ai';
```

### 2) Obtener cobertura de un servicio por plan

```sql
select rc.cobertura
from reglas_cobertura rc
where rc.plan_id = $1
  and rc.servicio_id = $2;
```

### 3) Obtener hospitales en red con costos por servicio

```sql
select h.nombre, h.ubicacion, sh.costo
from servicios_hospital sh
join hospitales h on h.id = sh.hospital_id
where sh.servicio_id = $1
  and h.en_red = true
order by sh.costo asc;
```

### 4) Calcular copago estimado

```sql
select
  s.nombre as servicio,
  sh.costo as costo_servicio,
  rc.cobertura,
  round((sh.costo * (1 - rc.cobertura))::numeric, 2) as copago_estimado
from reglas_cobertura rc
join servicios s on s.id = rc.servicio_id
join servicios_hospital sh on sh.servicio_id = s.id
join hospitales h on h.id = sh.hospital_id
where rc.plan_id = $1
  and rc.servicio_id = $2
  and h.en_red = true
order by copago_estimado asc;
```

## Checklist de validacion

- Se obtiene el plan de un usuario.
- Se obtiene la cobertura de un servicio.
- Se listan hospitales en red con precio.
- Se calcula copago manualmente con la formula: `copago = costo_servicio * (1 - cobertura)`.