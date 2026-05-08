-- Habilita funciones para generar UUID aleatorios.
create extension if not exists pgcrypto;

-- Elimina tablas en orden de dependencias para reconstruccion limpia.
drop table if exists historial_chat;
drop table if exists servicios_hospital;
drop table if exists reglas_cobertura;
drop table if exists usuarios;
drop table if exists servicios;
drop table if exists hospitales;
drop table if exists especialidades;
drop table if exists planes;

-- 📦 Planes de seguro
create table planes (
    id uuid primary key default gen_random_uuid(),
    nombre text not null unique,
    cobertura decimal(4,2) not null check (cobertura >= 0 and cobertura <= 1)
);

-- 🩺 Especialidades medicas
create table especialidades (
    id uuid primary key default gen_random_uuid(),
    nombre text not null unique
);

-- 💊 Servicios medicos
create table servicios (
    id uuid primary key default gen_random_uuid(),
    nombre text not null unique,
    especialidad_id uuid not null references especialidades(id) on delete restrict,
    costo_base decimal(10,2) not null check (costo_base >= 0)
);

-- 🏥 Hospitales
create table hospitales (
    id uuid primary key default gen_random_uuid(),
    nombre text not null unique,
    ubicacion text not null,
    en_red boolean not null default true
);

-- 👤 Usuarios
create table usuarios (
    id uuid primary key default gen_random_uuid(),
    nombre text not null,
    email text not null unique,
    plan_id uuid not null references planes(id) on delete restrict,
    creado_en timestamptz not null default now()
);

-- 💰 Reglas de cobertura por plan y servicio
create table reglas_cobertura (
    id uuid primary key default gen_random_uuid(),
    plan_id uuid not null references planes(id) on delete cascade,
    servicio_id uuid not null references servicios(id) on delete cascade,
    cobertura decimal(4,2) not null check (cobertura >= 0 and cobertura <= 1),
    unique (plan_id, servicio_id)
);

-- 🏥 Costos por hospital y servicio (clave del sistema)
create table servicios_hospital (
    id uuid primary key default gen_random_uuid(),
    hospital_id uuid not null references hospitales(id) on delete cascade,
    servicio_id uuid not null references servicios(id) on delete cascade,
    costo decimal(10,2) not null check (costo >= 0),
    unique (hospital_id, servicio_id)
);

-- 💬 Historial de chat
create table historial_chat (
    id uuid primary key default gen_random_uuid(),
    usuario_id uuid not null references usuarios(id) on delete cascade,
    mensaje text not null,
    respuesta jsonb not null,
    creado_en timestamptz not null default now()
);

-- Indices para consultas frecuentes del backend.
create index idx_usuarios_plan_id on usuarios(plan_id);
create index idx_servicios_especialidad_id on servicios(especialidad_id);
create index idx_reglas_cobertura_plan_servicio on reglas_cobertura(plan_id, servicio_id);
create index idx_reglas_cobertura_servicio_id on reglas_cobertura(servicio_id);
create index idx_servicios_hospital_servicio on servicios_hospital(servicio_id);
create index idx_hospitales_en_red on hospitales(en_red);
create index idx_historial_chat_usuario_id on historial_chat(usuario_id);

-- RLS y politicas basicas para acceso autenticado.
alter table planes enable row level security;
alter table especialidades enable row level security;
alter table servicios enable row level security;
alter table hospitales enable row level security;
alter table usuarios enable row level security;
alter table reglas_cobertura enable row level security;
alter table servicios_hospital enable row level security;
alter table historial_chat enable row level security;

drop policy if exists "lectura_planes_autenticado" on planes;
create policy "lectura_planes_autenticado"
on planes for select
to authenticated
using (true);

drop policy if exists "lectura_especialidades_autenticado" on especialidades;
create policy "lectura_especialidades_autenticado"
on especialidades for select
to authenticated
using (true);

drop policy if exists "lectura_servicios_autenticado" on servicios;
create policy "lectura_servicios_autenticado"
on servicios for select
to authenticated
using (true);

drop policy if exists "lectura_hospitales_autenticado" on hospitales;
create policy "lectura_hospitales_autenticado"
on hospitales for select
to authenticated
using (true);

drop policy if exists "lectura_reglas_cobertura_autenticado" on reglas_cobertura;
create policy "lectura_reglas_cobertura_autenticado"
on reglas_cobertura for select
to authenticated
using (true);

drop policy if exists "lectura_servicios_hospital_autenticado" on servicios_hospital;
create policy "lectura_servicios_hospital_autenticado"
on servicios_hospital for select
to authenticated
using (true);

drop policy if exists "lectura_usuario_propio" on usuarios;
create policy "lectura_usuario_propio"
on usuarios for select
to authenticated
using (email = (select auth.jwt()) ->> 'email');

drop policy if exists "lectura_historial_usuario_propio" on historial_chat;
create policy "lectura_historial_usuario_propio"
on historial_chat for select
to authenticated
using (
    exists (
        select 1
        from usuarios u
        where u.id = historial_chat.usuario_id
          and u.email = (select auth.jwt()) ->> 'email'
    )
);

drop policy if exists "insertar_historial_usuario_propio" on historial_chat;
create policy "insertar_historial_usuario_propio"
on historial_chat for insert
to authenticated
with check (
    exists (
        select 1
        from usuarios u
        where u.id = historial_chat.usuario_id
          and u.email = (select auth.jwt()) ->> 'email'
    )
);