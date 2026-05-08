-- Inserta datos semilla consistentes para pruebas del MVP.

-- 1) Planes
insert into planes (nombre, cobertura)
values
    ('Basico', 0.60),
    ('Premium', 0.80);

-- 2) Especialidades
insert into especialidades (nombre)
values
    ('Cardiologia'),
    ('Traumatologia'),
    ('Medicina General');

-- 3) Servicios
insert into servicios (nombre, especialidad_id, costo_base)
select 'Consulta cardiologica', e.id, 80.00
from especialidades e
where e.nombre = 'Cardiologia'
union all
select 'Consulta traumatologica', e.id, 70.00
from especialidades e
where e.nombre = 'Traumatologia'
union all
select 'Consulta general', e.id, 40.00
from especialidades e
where e.nombre = 'Medicina General';

-- 4) Hospitales
insert into hospitales (nombre, ubicacion, en_red)
values
    ('Hospital A', 'Centro', true),
    ('Hospital B', 'Norte', true),
    ('Hospital C', 'Sur', true),
    ('Hospital D', 'Este', false);

-- 5) Reglas de cobertura por plan y servicio
insert into reglas_cobertura (plan_id, servicio_id, cobertura)
select p.id, s.id,
    case
        when p.nombre = 'Basico' and s.nombre = 'Consulta cardiologica' then 0.60
        when p.nombre = 'Basico' and s.nombre = 'Consulta traumatologica' then 0.55
        when p.nombre = 'Basico' and s.nombre = 'Consulta general' then 0.70
        when p.nombre = 'Premium' and s.nombre = 'Consulta cardiologica' then 0.85
        when p.nombre = 'Premium' and s.nombre = 'Consulta traumatologica' then 0.80
        when p.nombre = 'Premium' and s.nombre = 'Consulta general' then 0.90
    end as cobertura
from planes p
cross join servicios s;

-- 6) Costos por hospital y servicio
insert into servicios_hospital (hospital_id, servicio_id, costo)
select h.id, s.id,
    case
        when h.nombre = 'Hospital A' and s.nombre = 'Consulta cardiologica' then 80.00
        when h.nombre = 'Hospital B' and s.nombre = 'Consulta cardiologica' then 76.00
        when h.nombre = 'Hospital C' and s.nombre = 'Consulta cardiologica' then 84.00
        when h.nombre = 'Hospital D' and s.nombre = 'Consulta cardiologica' then 72.00
        when h.nombre = 'Hospital A' and s.nombre = 'Consulta traumatologica' then 70.00
        when h.nombre = 'Hospital B' and s.nombre = 'Consulta traumatologica' then 68.00
        when h.nombre = 'Hospital C' and s.nombre = 'Consulta traumatologica' then 73.00
        when h.nombre = 'Hospital D' and s.nombre = 'Consulta traumatologica' then 65.00
        when h.nombre = 'Hospital A' and s.nombre = 'Consulta general' then 40.00
        when h.nombre = 'Hospital B' and s.nombre = 'Consulta general' then 38.00
        when h.nombre = 'Hospital C' and s.nombre = 'Consulta general' then 42.00
        when h.nombre = 'Hospital D' and s.nombre = 'Consulta general' then 35.00
    end as costo
from hospitales h
cross join servicios s;

-- 7) Usuarios de prueba
insert into usuarios (nombre, email, plan_id)
select 'Anthony Perez', 'anthony@medicost.ai', p.id
from planes p
where p.nombre = 'Premium'
union all
select 'Maria Lopez', 'maria@medicost.ai', p.id
from planes p
where p.nombre = 'Basico';

-- 8) Historial de chat de ejemplo
insert into historial_chat (usuario_id, mensaje, respuesta)
select u.id,
       'Tengo dolor en el pecho',
       jsonb_build_object(
           'especialidad', 'Cardiologia',
           'servicio', 'Consulta cardiologica',
           'hospital_recomendado', 'Hospital B'
       )
from usuarios u
where u.email = 'anthony@medicost.ai';
