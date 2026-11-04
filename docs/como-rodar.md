# Como rodar localmente

Este guia usa Windows, PowerShell e cópias de estudo das fotografias.

## Requisitos

- Java 25
- Cantaloupe 5.0.8 em `C:\oPovo\cantaloupe-5.0.8`
- Cópias de estudo em `C:\oPovo\imagens`
- Repositório em `C:\oPovo\o-povo-digital`

## Configuração do Cantaloupe

No arquivo `cantaloupe.properties`, use:

```properties
source.static = FilesystemSource
FilesystemSource.lookup_strategy = BasicLookupStrategy
FilesystemSource.BasicLookupStrategy.path_prefix = C:/oPovo/imagens/
```

## Ligar o Cantaloupe

Em um terminal:

```powershell
cd C:\oPovo\cantaloupe-5.0.8
java "-Dcantaloupe.config=cantaloupe.properties" -Xmx1g -jar cantaloupe-5.0.8.jar
```

Na versão 5.0.8, o terminal pode mostrar apenas `Loading config file`.

## Ligar o site

Em outro terminal:

```powershell
jwebserver -p 8000 -d C:\oPovo\o-povo-digital\site
```

## Abrir o projeto

- Mirador: http://localhost:8000
- Cantaloupe: http://localhost:8182/iiif/3

## Desligar

Pressione `Ctrl+C` nos dois terminais.