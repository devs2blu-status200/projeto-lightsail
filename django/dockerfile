# Use a imagem base do Python
FROM python:3.9

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo Pipfile e Pipfile.lock para o diretório de trabalho
COPY Pipfile Pipfile.lock /app/

# Instale o Pipenv
RUN pip install pipenv

# Instale as dependências do projeto usando o Pipenv
RUN pipenv install --deploy --ignore-pipfile

# Copie todo o conteúdo do diretório 'project' para o diretório de trabalho
COPY project/ /app/

# Comando para rodar o servidor de desenvolvimento do Django com Pipenv
CMD ["pipenv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
