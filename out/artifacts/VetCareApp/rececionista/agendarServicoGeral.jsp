<%@ page import="java.util.List" %>
<%@ page import="model.Paciente" %>
<%@ page import="model.Utilizador.Veterinario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Paciente> animais = (List<Paciente>) request.getAttribute("listaAnimais");
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("listaVets");
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novo Agendamento - VetCare</title>
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
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .header h2 {
            color: #2d3748;
            font-size: 26px;
            font-weight: 600;
        }

        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 1px solid #e2e8f0;
        }

        .form-section:last-of-type {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .form-group .label-number {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            text-align: center;
            line-height: 28px;
            margin-right: 10px;
            font-size: 14px;
            font-weight: 700;
        }

        input[type="text"],
        input[type="datetime-local"],
        select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: white;
            color: #2d3748;
        }

        input[type="text"]:focus,
        input[type="datetime-local"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 20px;
            padding-right: 40px;
        }

        .help-text {
            display: block;
            margin-top: 8px;
            color: #718096;
            font-size: 13px;
            line-height: 1.5;
        }

        .vets-list {
            background: #f7fafc;
            padding: 12px 16px;
            border-radius: 8px;
            margin-top: 8px;
            border-left: 3px solid #667eea;
        }

        .vet-item {
            display: inline-block;
            margin-right: 15px;
            margin-bottom: 5px;
            color: #4a5568;
            font-size: 13px;
        }

        .vet-id {
            background: #667eea;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
            margin-right: 5px;
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
            margin-top: 30px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            .container {
                padding: 0;
            }

            .header {
                padding: 20px;
            }

            .header h2 {
                font-size: 22px;
                width: 100%;
                text-align: center;
            }

            .btn-back {
                width: 100%;
                text-align: center;
            }

            .form-container {
                padding: 25px 20px;
            }

            .form-section {
                margin-bottom: 25px;
                padding-bottom: 25px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>Agendar Novo Serviço</h2>
        <a href="${pageContext.request.contextPath}/rececionista/menuRece.jsp" class="btn-back">Voltar ao Menu</a>
    </div>

    <div class="form-container">
        <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post">
            <input type="hidden" name="action" value="criar">

            <div class="form-section">
                <div class="form-group">
                    <label>
                        <span class="label-number">1</span>
                        Selecione o Animal
                    </label>
                    <select name="idPaciente" required>
                        <option value="" disabled selected>Escolha o paciente...</option>
                        <% if(animais != null) {
                            for(Paciente p : animais) { %>
                        <option value="<%= p.getidPaciente() %>">
                            <%= p.getNome() %> - Proprietário: <%= p.getNifDono() %>
                        </option>
                        <% }} %>
                    </select>
                </div>

                <div class="form-group">
                    <label>
                        <span class="label-number">2</span>
                        Tipo de Serviço
                    </label>
                    <select name="tipoServico" required>
                        <option value="" disabled selected>Selecione o tipo de serviço...</option>
                        <option value="Consulta">Consulta</option>
                        <option value="Vacinacao">Vacinação</option>
                        <option value="Cirurgia">Cirurgia</option>
                        <option value="Exame">Exame</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>
                        <span class="label-number">3</span>
                        Descrição do Serviço
                    </label>
                    <input type="text" name="descricao" placeholder="Descreva brevemente o motivo da consulta...">
                </div>
            </div>

            <div class="form-section">
                <div class="form-group">
                    <label>
                        <span class="label-number">4</span>
                        Data e Hora do Agendamento
                    </label>
                    <input type="datetime-local" name="dataHora" required>
                    <span class="help-text">Selecione a data e hora pretendidas para o serviço</span>
                </div>

                <div class="form-group">
                    <label>
                        <span class="label-number">5</span>
                        Identificador do Veterinário
                    </label>
                    <input type="text" name="idVeterinario" placeholder="Insira o ID do veterinário" required>

                    <% if(vets != null && !vets.isEmpty()) { %>
                    <div class="vets-list">
                        <strong style="display: block; margin-bottom: 8px; color: #2d3748;">Veterinários Disponíveis:</strong>
                        <% for(Veterinario v : vets) { %>
                        <span class="vet-item">
                            <span class="vet-id"><%= v.getiDUtilizador() %></span>
                            <%= v.getNome() %>
                        </span>
                        <% } %>
                    </div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label>
                        <span class="label-number">6</span>
                        Clínica
                    </label>
                    <select name="localidade" required>
                        <option value="" disabled selected>Selecione a clínica...</option>
                        <option value="Serpa">Serpa</option>
                        <option value="Odivelas">Odivelas</option>
                        <option value="Quinta do Conde">Quinta do Conde</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-submit">Confirmar Agendamento</button>
        </form>
    </div>
</div>
</body>
</html>