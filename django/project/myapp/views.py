from django.shortcuts import render
from django.db import connection

# Create your views here.

def index(request):
    return render(request, 'index.html')
def quantidade_tabelas(request):
    with connection.cursor() as cursor:
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            tables = [table[0] for table in cursor.fetchall()]



    return render(request, 'quantidade_tabelas.html', {'numero_tables': len(tables), 'tables': tables})