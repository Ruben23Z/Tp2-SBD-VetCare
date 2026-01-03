<%@ page import="model.Paciente.Paciente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Paciente p = (Paciente) request.getAttribute("animal"); %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendar Serviço para <%= p.getNome() %> | VetCare</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 600px;
        }

        .header-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .header-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 28px;
            flex-shrink: 0;
        }

        .header-text h2 {
            color: #2d3748;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .header-text p {
            color: #718096;
            font-size: 14px;
        }

        .form-box {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 35px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .form-title {
            color: #2d3748;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .form-group label i {
            color: #667eea;
            font-size: 16px;
        }

        .input-wrapper {
            position: relative;
        }

        input[type="text"],
        input[type="datetime-local"],
        select {
            width: 100%;
            padding: 12px 16px;
            padding-left: 45px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
            color: #2d3748;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        input[type="text"]:focus,
        input[type="datetime-local"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 16px;
            pointer-events: none;
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23667eea' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 18px;
            padding-right: 45px;
        }

        input::placeholder {
            color: #cbd5e0;
        }

        .help-text {
            color: #718096;
            font-size: 12px;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .help-text i {
            font-size: 14px;
            color: #a0aec0;
        }

        .info-banner {
            background: linear-gradient(135deg, #e6f3ff 0%, #d4e9ff 100%);
            border-left: 4px solid #3182ce;
            padding: 15px 18px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .info-banner i {
            font-size: 20px;
            color: #2c5282;
        }

        .info-banner p {
            color: #2c5282;
            font-size: 13px;
            margin: 0;
            line-height: 1.5;
        }

        .service-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-top: 12px;
        }

        .service-card {
            background: #f7fafc;
            padding: 14px;
            border-radius: 10px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            cursor: pointer;
            text-align: center;
        }

        .service-card:hover {
            background: #edf2f7;
            border-color: #667eea;
            transform: translateY(-2px);
        }

        .service-card i {
            font-size: 28px;
            color: #667eea;
            display: block;
            margin-bottom: 8px;
        }

        .service-card span {
            font-size: 13px;
            font-weight: 600;
            color: #4a5568;
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-submit i {
            font-size: 18px;
        }

        .btn-cancel {
            display: block;
            width: 100%;
            padding: 14px;
            margin-top: 15px;
            text-align: center;
            color: #718096;
            text-decoration: none;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-cancel:hover {
            background: #f7fafc;
            color: #2d3748;
        }

        .btn-cancel i {
            font-size: 16px;
        }

        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .form-box {
                padding: 25px 20px;
            }

            .header-card {
                padding: 20px;
            }

            .header-icon {
                width: 50px;
                height: 50px;
                font-size: 24px;
            }

            .header-text h2 {
                font-size: 20px;
            }

            .service-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-card">
        <div class="header-icon">
            <i class="bi bi-calendar-plus"></i>
        </div>
        <div class="header-text">
            <h2>Agendar Serviço Veterinário</h2>
            <p>Paciente: <%= p.getNome() %> - <%= p.getRaca() %></p>
        </div>
    </div>

    <div class="form-box">
        <div class="info-banner">
            <i class="bi bi-info-circle"></i>
            <p>Preencha os dados abaixo. A equipa entrará em contacto para confirmar o agendamento.</p>
        </div>

        <h3 class="form-title">Detalhes do Agendamento</h3>

        <form action="${pageContext.request.contextPath}/TutorServlet" method="post">
            <input type="hidden" name="action" value="criar">
            <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">

            <div class="form-group">
                <label>
                    <i class="bi bi-clipboard-pulse"></i>
                    Tipo de Serviço
                </label>
                <div class="input-wrapper">
                    <i class="bi bi-chevron-down input-icon"></i>
                    <select name="tipoServico" required>
                        <option value="" disabled selected>Selecione o tipo de serviço...</option>
                        <option value="Consulta">Consulta Geral</option>
                        <option value="Vacinacao">Vacinação</option>
                        <option value="Desparasitacao">Desparasitação</option>
                        <option value="Exame">Exame / Análises</option>
                        <option value="Cirurgia">Cirurgia</option>
                        <option value="TratamentoTerapeutico">Tratamento Terapêutico</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-file-text"></i>
                    Descrição / Motivo da Consulta
                </label>
                <div class="input-wrapper">
                    <i class="bi bi-pencil input-icon"></i>
                    <input type="text"
                           name="descricao"
                           required
                           placeholder="Ex: Check-up anual, vacina antirrábica...">
                </div>
                <span class="help-text">
                    <i class="bi bi-lightbulb"></i>
                    Descreva os sintomas ou o motivo da consulta
                </span>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-calendar-event"></i>
                    Data e Hora Preferida
                </label>
                <div class="input-wrapper">
                    <i class="bi bi-clock input-icon"></i>
                    <input type="datetime-local" name="dataHora" required>
                </div>
                <span class="help-text">
                    <i class="bi bi-info-circle"></i>
                    Sujeito a disponibilidade da clínica
                </span>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-geo-alt"></i>
                    Clínica Preferida
                </label>
                <div class="input-wrapper">
                    <i class="bi bi-building input-icon"></i>
                    <select name="localidade" required>
                        <option value="" disabled selected>Selecione a clínica...</option>
                        <option value="Serpa">VetCare Serpa</option>
                        <option value="Odivelas">VetCare Odivelas</option>
                        <option value="Quinta do Conde">VetCare Quinta do Conde</option>
                    </select>
                </div>
                <span class="help-text">
                    <i class="bi bi-pin-map"></i>
                    Escolha a clínica mais conveniente
                </span>
            </div>

            <button type="submit" class="btn-submit">
                <i class="bi bi-check-circle"></i>
                Confirmar Agendamento
            </button>
        </form>

        <a href="javascript:history.back()" class="btn-cancel">
            <i class="bi bi-arrow-left"></i>
            Cancelar e Voltar
        </a>
    </div>
</div>

</body>
</html>