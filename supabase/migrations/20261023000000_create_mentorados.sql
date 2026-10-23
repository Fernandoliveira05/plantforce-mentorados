-- PlantForce · confirmações de participação dos Jovens Sementes (site para mentorados)
create table if not exists public.mentorados (
  id                        uuid primary key default gen_random_uuid(),
  nome                      text not null check (char_length(btrim(nome)) between 2 and 120),
  email                     text not null check (
                              char_length(email) <= 254
                              and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'
                            ),
  curso                     text not null check (char_length(btrim(curso)) between 2 and 120),
  instituicao               text not null check (char_length(btrim(instituicao)) between 2 and 120),
  area_interesse            text not null check (area_interesse in ('consultoria', 'vendas', 'engenharia', 'descobrindo')),
  confirmacao_participacao  boolean not null default true check (confirmacao_participacao),
  created_at                timestamptz not null default now()
);

comment on table public.mentorados is
  'Jovens Sementes que confirmaram participação no PlantForce (jan–abr 2027).';

-- Um registro por e-mail (sem diferenciar maiúsculas/minúsculas)
create unique index if not exists mentorados_email_key on public.mentorados (lower(email));

-- O site usa a chave pública: com RLS e só uma política de INSERT, ele pode inserir, mas nunca ler, editar ou apagar.
alter table public.mentorados enable row level security;

grant insert on table public.mentorados to anon, authenticated;

create policy "Site pode registrar confirmação de participação"
  on public.mentorados
  for insert
  to anon, authenticated
  with check (confirmacao_participacao);
