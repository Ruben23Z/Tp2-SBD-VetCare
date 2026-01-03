<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare - Registo</title>
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
            max-width: 600px;
            margin: 0 auto;
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h2 {
            color: #667eea;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .header .icon {
            font-size: 48px;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f9f9f9;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        input:hover, select:hover {
            border-color: #b8c5f2;
        }

        button {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        button:active {
            transform: translateY(0);
        }

        .hidden {
            display: none;
        }

        .info-box {
            background: #f0f4ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            color: #555;
            font-size: 14px;
        }

        .section-title {
            color: #667eea;
            font-size: 18px;
            margin: 25px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .paw-print {
            display: inline-block;
            margin-right: 8px;
        }

        @media (max-width: 600px) {
            .container {
                padding: 25px;
            }

            .header h2 {
                font-size: 24px;
            }
        }
    </style>

    <script>
        function mostrarFormulario() {
            const cargo = document.getElementById("cargo").value;

            document.querySelectorAll(".form-cargo").forEach(div => {
                div.classList.add("hidden");
                div.querySelectorAll("input, select").forEach(el => el.required = false);
            });

            if (!cargo) return;

            const ativo = document.getElementById("form-" + cargo);
            ativo.classList.remove("hidden");
            ativo.querySelectorAll("input, select").forEach(el => {
                if (el.name !== "capitalSocial" && el.name !== "prefLinguistica") {
                    el.required = true;
                }
            });
        }

        function mostrarCamposCliente() {
            const tipo = document.querySelector("[name='tipoCliente']").value;
            const particular = document.getElementById("campos-particular");
            const empresa = document.getElementById("campos-empresa");

            if (tipo === "Particular") {
                particular.classList.remove("hidden");
                empresa.classList.add("hidden");
                document.querySelector("[name='capitalSocial']").required = false;
                document.querySelector("[name='prefLinguistica']").required = false;
            } else if (tipo === "Empresa") {
                particular.classList.add("hidden");
                empresa.classList.remove("hidden");
                document.querySelector("[name='capitalSocial']").required = true;
                document.querySelector("[name='prefLinguistica']").required = false;
            }
        }

        function validarFormulario() {
            const cargo = document.getElementById("cargo").value;

            if (cargo === "Cliente") {
                const telefone = document.querySelector("[name='telefone']").value;
                const nif = document.querySelector("[name='nif']").value;

                if (!/^\+[0-9]{1,4} [0-9]{9}$/.test(telefone)) {
                    alert(" Telefone inválido. Use o formato +351 912345678");
                    return false;
                }

                if (!/^\d{9}$/.test(nif)) {
                    alert(" NIF inválido (9 dígitos).");
                    return false;
                }

                const tipo = document.querySelector("[name='tipoCliente']").value;
                if (tipo === "Empresa") {
                    const capital = document.querySelector("[name='capitalSocial']").value;
                    if (!capital || Number(capital) <= 0) {
                        alert(" Capital social obrigatório e maior que 0 para empresas.");
                        return false;
                    }
                }
            }
            return true;
        }
    </script>
</head>

<body>
<div class="container">
    <div class="header">
        <div class="icon">🐾</div>
        <h2>VetCare</h2>
        <p>Crie a sua conta e cuide dos seus amigos de 4 patas</p>
    </div>

    <form action="registo" method="post" onsubmit="return validarFormulario()">

        <div class="section-title">
            <span class="paw-print">🔐</span> Dados de Acesso
        </div>

        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" required minlength="4" placeholder="Escolha o seu username">
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required minlength="6" placeholder="Mínimo 6 caracteres">
        </div>

        <div class="section-title">
            <span class="paw-print">👤</span> Tipo de Conta
        </div>

        <div class="form-group">
            <label>Cargo</label>
            <select name="cargo" id="cargo" required onchange="mostrarFormulario()">
                <option value="">-- Selecione o tipo de conta --</option>
                <option value="Cliente">🐶 Cliente (Tutor de Animal)</option>
                <option value="Veterinario">🩺 Veterinário</option>
                <option value="Rececionista">📋 Rececionista</option>
                <option value="Gerente">💼 Gerente</option>
            </select>
        </div>

        <!-- ================= CLIENTE ================= -->
        <div id="form-Cliente" class="form-cargo hidden">

            <div class="section-title">
                <span class="paw-print">📝</span> Informações do Cliente
            </div>

            <div class="form-group">
                <label>Tipo de Cliente</label>
                <select name="tipoCliente" onchange="mostrarCamposCliente()">
                    <option value="Particular">Particular</option>
                    <option value="Empresa">Empresa</option>
                </select>
            </div>

            <div class="form-group">
                <label>Nome Completo</label>
                <input type="text" name="nomeCliente" placeholder="Nome completo ou razão social">
            </div>

            <div class="form-group">
                <label>NIF</label>
                <input type="text" name="nif" pattern="\d{9}" title="9 dígitos" placeholder="123456789">
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="exemplo@email.com">
            </div>

            <div class="form-group">
                <label>Telefone</label>
                <input type="text" name="telefone" placeholder="+351 912345678"
                       pattern="^\+[0-9]{1,4} [0-9]{9}$" title="Formato: +<código país> <número (9 dígitos)>">
            </div>

            <div class="section-title">
                <span class="paw-print">🏠</span> Morada
            </div>

            <div class="form-group">
                <label>Rua</label>
                <input type="text" name="rua" placeholder="Rua e número">
            </div>

            <div class="form-group">
                <label>País</label>
                <input type="text" name="pais" value="Portugal">
            </div>

            <div class="form-group">
                <label>Distrito</label>
                <input type="text" name="distrito" placeholder="Ex: Lisboa, Porto, Faro">
            </div>

            <div class="form-group">
                <label>Concelho</label>
                <input type="text" name="concelho" placeholder="Ex: Sintra, Matosinhos">
            </div>

            <div class="form-group">
                <label>Freguesia</label>
                <input type="text" name="freguesia" placeholder="Ex: São João">
            </div>

            <!-- Campos Particular -->
            <div id="campos-particular">
                <div class="form-group">
                    <label>Preferência Linguística (Opcional)</label>
                    <input type="text" name="prefLinguistica" placeholder="Ex: Português, Inglês">
                </div>
            </div>

            <!-- Campos Empresa -->
            <div id="campos-empresa" class="hidden">
                <div class="form-group">
                    <label>Capital Social (€) *</label>
                    <input type="number" name="capitalSocial" min="1" step="0.01" placeholder="Ex: 50000">
                </div>
            </div>

        </div>

        <!-- ================= VETERINÁRIO ================= -->
        <div id="form-Veterinario" class="form-cargo hidden">
            <div class="section-title">
                <span class="paw-print">🩺</span> Dados do Veterinário
            </div>

            <div class="form-group">
                <label>Nome Completo</label>
                <input type="text" name="nomeVet" placeholder="Nome do veterinário">
            </div>

            <div class="form-group">
                <label>Idade</label>
                <input type="number" name="idade" min="21" placeholder="Idade (mínimo 21 anos)">
            </div>

            <div class="form-group">
                <label>Especialidade</label>
                <input type="text" name="especialidade" placeholder="Ex: Cirurgia, Dermatologia">
            </div>
        </div>

        <!-- ================= RECECIONISTA ================= -->
        <div id="form-Rececionista" class="form-cargo hidden">
            <div class="info-box">
                Rececionista não requer dados adicionais. Complete os dados de acesso acima.
            </div>
        </div>

        <!-- ================= GERENTE ================= -->
        <div id="form-Gerente" class="form-cargo hidden">
            <div class="info-box">
                Gerente não requer dados adicionais. Complete os dados de acesso acima.
            </div>
        </div>

        <button type="submit">🐾 Criar Conta</button>
    </form>
</div>
</body>
</html>