<%@ page import="model.Paciente.Paciente" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Paciente> animais = (List<Paciente>) request.getAttribute("animais");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Importar/Exportar Dados - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin-bottom: 25px;
            backdrop-filter: blur(10px);
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateX(-5px);
        }

        .alert-custom {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            animation: slideDown 0.3s ease;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border-left: 4px solid var(--success-color);
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-custom i {
            font-size: 1.3rem;
        }

        .content-wrapper {
            display: grid;
            grid-template-columns: 1fr;
            gap: 25px;
        }

        .card-custom {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 25px 30px;
        }

        .card-header-custom h3 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header-custom .subtitle {
            margin-top: 8px;
            font-size: 0.9rem;
            opacity: 0.95;
        }

        .card-body-custom {
            padding: 30px;
        }

        .description-text {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 20px;
            display: flex;
            align-items: start;
            gap: 10px;
            background: #f8f9fa;
            padding: 12px;
            border-radius: 8px;
            border-left: 3px solid var(--info-color);
        }

        .description-text i {
            color: var(--info-color);
            margin-top: 2px;
        }

        .animal-list {
            list-style: none;
            padding: 0;
            margin: 0;
            max-height: 400px;
            overflow-y: auto;
        }

        .animal-list::-webkit-scrollbar {
            width: 8px;
        }

        .animal-list::-webkit-scrollbar-track {
            background: #f1f3f5;
            border-radius: 10px;
        }

        .animal-list::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 10px;
        }

        .animal-item {
            padding: 16px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s ease;
        }

        .animal-item:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }

        .animal-item:last-child {
            border-bottom: none;
        }

        .animal-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .animal-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1976d2;
            font-size: 1.2rem;
        }

        .animal-name {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 3px;
        }

        .animal-id {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .download-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-download {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-json {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
        }

        .btn-json:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-xml {
            background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);
        }

        .btn-xml:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(23, 162, 184, 0.4);
        }

        .import-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .import-card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .import-card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.15);
        }

        .import-card h4 {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #2d3748;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }

        .import-card h4 i {
            color: var(--primary-color);
            font-size: 1.3rem;
        }

        .form-control-json,
        .form-control-xml {
            width: 100%;
            height: 200px;
            padding: 15px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background-color: white;
            resize: vertical;
        }

        .form-control-json:focus,
        .form-control-xml:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-import {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 15px;
        }

        .btn-import:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-state i {
            font-size: 3rem;
            color: #dee2e6;
            margin-bottom: 15px;
        }

        .empty-state p {
            color: #6c757d;
            margin: 0;
        }

        .code-hint {
            background: #fff3cd;
            border-left: 3px solid #ffc107;
            padding: 10px 12px;
            border-radius: 8px;
            margin-bottom: 12px;
            font-size: 0.8rem;
            color: #856404;
        }

        .code-hint strong {
            display: block;
            margin-bottom: 3px;
        }

        .stats-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 6px 12px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.9rem;
            margin-top: 10px;
            backdrop-filter: blur(10px);
        }

        @media (max-width: 992px) {
            .import-section {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 20px 10px;
            }

            .card-header-custom {
                padding: 20px;
            }

            .card-header-custom h3 {
                font-size: 1.2rem;
            }

            .card-body-custom {
                padding: 20px;
            }

            .animal-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
                padding: 12px;
            }

            .download-buttons {
                width: 100%;
                justify-content: flex-end;
            }

            .form-control-json,
            .form-control-xml {
                height: 180px;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <a href="GerenteServlet?action=dashboard" class="back-button">
        <i class="bi bi-arrow-left"></i>
        <span>Voltar ao Dashboard</span>
    </a>

    <% if ("importado".equals(msg)) { %>
    <div class="alert-custom">
        <i class="bi bi-check-circle-fill"></i>
        <span>Ficha importada com sucesso!</span>
    </div>
    <% } %>

    <div class="content-wrapper">
        <!-- Exportar -->
        <div class="card-custom">
            <div class="card-header-custom">
                <h3>
                    <i class="bi bi-download"></i>
                    Exportar Fichas Clínicas
                </h3>
                <div class="subtitle">
                    <i class="bi bi-file-earmark-code"></i>
                    Descarregar dados em formato JSON ou XML
                </div>
                <% if(animais != null && !animais.isEmpty()) { %>
                <div class="stats-badge">
                    <i class="bi bi-database"></i>
                    <span><%= animais.size() %> <%= animais.size() == 1 ? "animal disponível" : "animais disponíveis" %></span>
                </div>
                <% } %>
            </div>

            <div class="card-body-custom">
                <div class="description-text">
                    <i class="bi bi-info-circle"></i>
                    <span>Selecione um animal da lista para descarregar os seus dados nos formatos JSON ou XML.
                    Estes ficheiros podem ser utilizados para backup ou transferência de dados entre sistemas.</span>
                </div>

                <% if(animais != null && !animais.isEmpty()) { %>
                <ul class="animal-list">
                    <% for(Paciente p : animais) { %>
                    <li class="animal-item">
                        <div class="animal-info">
                            <div class="animal-icon">
                                <i class="bi bi-heart-pulse"></i>
                            </div>
                            <div>
                                <div class="animal-name"><%= p.getNome() %></div>
                                <div class="animal-id">ID: <%= p.getidPaciente() %></div>
                            </div>
                        </div>
                        <div class="download-buttons">
                            <a href="GerenteServlet?action=downloadJSON&idPaciente=<%= p.getidPaciente() %>"
                               class="btn-download btn-json">
                                <i class="bi bi-filetype-json"></i>
                                <span>JSON</span>
                            </a>
                            <a href="GerenteServlet?action=downloadXML&idPaciente=<%= p.getidPaciente() %>"
                               class="btn-download btn-xml">
                                <i class="bi bi-filetype-xml"></i>
                                <span>XML</span>
                            </a>
                        </div>
                    </li>
                    <% } %>
                </ul>
                <% } else { %>
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <p>Nenhum animal registado no sistema.</p>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Importar -->
        <div class="card-custom">
            <div class="card-header-custom">
                <h3>
                    <i class="bi bi-upload"></i>
                    Importar Fichas Clínicas
                </h3>
                <div class="subtitle">
                    <i class="bi bi-file-earmark-plus"></i>
                    Adicionar dados a partir de ficheiros JSON ou XML
                </div>
            </div>

            <div class="card-body-custom">
                <div class="description-text">
                    <i class="bi bi-info-circle"></i>
                    <span>Cole o conteúdo completo do ficheiro JSON ou XML no campo correspondente para importar
                    os dados de um animal para o sistema.</span>
                </div>

                <div class="import-section">
                    <!-- Importar JSON -->
                    <div class="import-card">
                        <h4>
                            <i class="bi bi-filetype-json"></i>
                            Formato JSON
                        </h4>

                        <div class="code-hint">
                            <strong><i class="bi bi-lightbulb"></i> Dica:</strong>
                            O JSON deve estar corretamente formatado com todos os campos obrigatórios.
                        </div>

                        <form action="GerenteServlet" method="post">
                            <input type="hidden" name="action" value="importarJSON">
                            <textarea name="jsonContent"
                                      class="form-control-json"
                                      placeholder='Cole aqui o conteúdo JSON...

Exemplo:
{
  "nome": "Rex",
  "raca": "Pastor Alemão",
  "idade": 5,
  "peso": 32.5
}'
                                      required></textarea>
                            <button type="submit" class="btn-import">
                                <i class="bi bi-cloud-upload"></i>
                                <span>Importar JSON</span>
                            </button>
                        </form>
                    </div>

                    <!-- Importar XML -->
                    <div class="import-card">
                        <h4>
                            <i class="bi bi-filetype-xml"></i>
                            Formato XML
                        </h4>

                        <div class="code-hint">
                            <strong><i class="bi bi-lightbulb"></i> Dica:</strong>
                            O XML deve ter as tags corretas e estar bem estruturado.
                        </div>

                        <form action="GerenteServlet" method="post">
                            <input type="hidden" name="action" value="importarXML">
                            <textarea name="xmlContent"
                                      class="form-control-xml"
                                      placeholder='Cole aqui o conteúdo XML...

Exemplo:
<?xml version="1.0"?>
<animal>
  <nome>Rex</nome>
  <raca>Pastor Alemão</raca>
  <idade>5</idade>
  <peso>32.5</peso>
</animal>'
                                      required></textarea>
                            <button type="submit" class="btn-import">
                                <i class="bi bi-cloud-upload"></i>
                                <span>Importar XML</span>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>