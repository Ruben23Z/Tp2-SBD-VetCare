<%@ page import="model.Utilizador.Veterinario" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("vets");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Horários - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --danger-color: #dc3545;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 650px;
            margin: 0 auto;
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
            padding: 30px;
            border: none;
        }

        .card-header-custom h2 {
            margin: 0;
            font-size: 1.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-header-custom .subtitle {
            margin-top: 8px;
            font-size: 0.95rem;
            opacity: 0.95;
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
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateX(-5px);
        }

        .card-body-custom {
            padding: 40px;
        }

        .form-group-custom {
            margin-bottom: 25px;
        }

        .form-label-custom {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .form-label-custom i {
            color: var(--primary-color);
        }

        .form-select-custom,
        .form-control-custom {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: #f8f9fa;
        }

        .form-select-custom:focus,
        .form-control-custom:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-select-custom option {
            padding: 10px;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-submit:active {
            transform: translateY(0);
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

        .alert-success-custom {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border-left: 4px solid var(--success-color);
        }

        .alert-danger-custom {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border-left: 4px solid var(--danger-color);
        }

        .alert-custom i {
            font-size: 1.3rem;
        }

        .form-info {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: start;
            gap: 12px;
        }

        .form-info i {
            color: #2196f3;
            font-size: 1.2rem;
            margin-top: 2px;
        }

        .form-info-text {
            flex: 1;
            font-size: 0.9rem;
            color: #1565c0;
        }

        .required-indicator {
            color: var(--danger-color);
            margin-left: 4px;
        }

        @media (max-width: 768px) {
            .card-header-custom {
                padding: 20px;
            }

            .card-header-custom h2 {
                font-size: 1.4rem;
            }

            .card-body-custom {
                padding: 25px;
            }

            .form-select-custom,
            .form-control-custom {
                padding: 10px 14px;
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

    <div class="card-custom">
        <div class="card-header-custom">
            <h2>
                <i class="bi bi-calendar-week"></i>
                Gestão de Horários
            </h2>
            <div class="subtitle">
                <i class="bi bi-clipboard-check"></i>
                Atribuição de supervisão veterinária às clínicas
            </div>
        </div>

        <div class="card-body-custom">
            <% if ("sucesso".equals(msg)) { %>
            <div class="alert-custom alert-success-custom">
                <i class="bi bi-check-circle-fill"></i>
                <span>Horário atribuído com sucesso!</span>
            </div>
            <% } else if ("erroConflito".equals(msg)) { %>
            <div class="alert-custom alert-danger-custom">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span>Erro: Sobreposição de horários ou dia inválido (fim de semana).</span>
            </div>
            <% } else if ("erroBD".equals(msg)) { %>
            <div class="alert-custom alert-danger-custom">
                <i class="bi bi-exclamation-octagon-fill"></i>
                <span>Erro ao comunicar com a base de dados. Por favor, tente novamente.</span>
            </div>
            <% } %>

            <div class="form-info">
                <i class="bi bi-info-circle-fill"></i>
                <div class="form-info-text">
                    <strong>Informação:</strong> Os horários são atribuídos para dias úteis (segunda a sexta-feira).
                    Certifique-se de que não existem conflitos com horários já definidos para o veterinário selecionado.
                </div>
            </div>

            <form action="GerenteServlet" method="post">
                <input type="hidden" name="action" value="atribuirHorario">

                <div class="form-group-custom">
                    <label class="form-label-custom">
                        <i class="bi bi-person-badge"></i>
                        Veterinário
                        <span class="required-indicator">*</span>
                    </label>
                    <select name="nLicenca" class="form-select-custom" required>
                        <option value="">Selecione um veterinário...</option>
                        <% if(vets != null) for(Veterinario v : vets) { %>
                        <option value="<%= v.getnLicenca() %>">
                            <%= v.getNome() %> (Licença: <%= v.getnLicenca() %>)
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group-custom">
                    <label class="form-label-custom">
                        <i class="bi bi-hospital"></i>
                        Clínica Veterinária
                        <span class="required-indicator">*</span>
                    </label>
                    <select name="localidade" class="form-select-custom" required>
                        <option value="Serpa">Serpa</option>
                        <option value="Odivelas">Odivelas</option>
                        <option value="Quinta do Conde">Quinta do Conde</option>
                    </select>
                </div>

                <div class="form-group-custom">
                    <label class="form-label-custom">
                        <i class="bi bi-calendar-day"></i>
                        Dia da Semana
                        <span class="required-indicator">*</span>
                    </label>
                    <select name="diaUtil" class="form-select-custom" required>
                        <option value="SEG">Segunda-feira</option>
                        <option value="TER">Terça-feira</option>
                        <option value="QUA">Quarta-feira</option>
                        <option value="QUI">Quinta-feira</option>
                        <option value="SEX">Sexta-feira</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="bi bi-check-circle"></i>
                    <span>Atribuir Horário</span>
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>