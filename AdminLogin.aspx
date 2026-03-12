<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="ghost_series.AdminLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        @import url("https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800,900&display=swap");
        @import url("https://use.fontawesome.com/releases/v6.5.1/css/all.css");

        @property --a {
            syntax: "<angle>";
            inherits: false;
            initial-value: 0deg;
        }
        /* Full height content area from MasterPage */
        .main-content {
            min-height: calc(100vh - 160px); /* navbar + footer space */
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #0f0f1a, #1f1f2e);
            padding: 40px 0;
        }


        /* Make footer naturally stay at bottom */
        footer {
            margin-top: auto;
        }

        .box {
            position: relative;
            width: 450px;
            height: 200px;
            border-radius: 20px;
            background: #2d2d39;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 15px 40px rgba(0,0,0,.7);
        }

        h2 {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.2em;
            white-space: nowrap;
        }

            h2 i {
                margin: 0;
            }

        @keyframes rotating {
            0% {
                --a: 0deg;
            }

            0% {
                --a: 360deg;
            }
        }

        .box::before {
            content: "";
            position: absolute;
            inset: -3px;
            background: linear-gradient( 90deg, #ff2770, #45f3ff, #ff2770 );
            animation: spin 3s linear infinite;
        }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }

            to {
                transform: rotate(360deg);
            }
        }

        .box::after {
            content: "";
            position: absolute;
            inset: 6px;
            background: #2d2d39;
            border-radius: 15px;
        }

        .box:hover {
            width: 450px;
            height: 500px;
        }

            .box:hover .login {
                inset: 40px;
            }

            .box:hover .loginBx {
                transform: translateY(0px);
            }

        .login {
            position: absolute;
            inset: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            border-radius: 10px;
            background: #00000033;
            color: #fff;
            z-index: 1000;
            box-shadow: inset 0 10px 20px #00000080;
            border-bottom: 2px solid #ffffff80;
            transition: 0.5s;
            overflow: hidden;
        }

        .loginBx {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            gap: 20px;
            width: 70%;
            transform: translateY(126px);
            transition: 0.5s;
        }

        h2 {
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.2em;
        }

            h2 i {
                color: #ff2770;
                text-shadow: 0 0 5px #ff2770, 0 0 20px #ff2770;
            }

        input {
            width: 100%;
            padding: 10px 20px;
            outline: none;
            border: none;
            font-size: 1em;
            color: #fff;
            background: #0000001a;
            border: 2px solid #fff;
            border-radius: 30px;
        }

            input::placeholder {
                color: #999;
            }

            input[type="submit"] {
                background: #45f3ff;
                border: none;
                font-weight: 500;
                color: #111;
                cursor: pointer;
                transition: 0.5s;
            }

                input[type="submit"]:hover {
                    box-shadow: 0 0 10px #45f3ff, 0 0 60px #45f3ff;
                }

        .group {
            width: 100%;
            display: flex;
            justify-content: space-around;
        }

            .group a {
                color: #fff;
                text-decoration: none;
            }

                .group a:nth-child(2) {
                    color: #ff2770;
                    font-weight: 600;
                }

        .password-wrap {
            position: relative;
            width: 100%;
        }

        .password-input {
            width: 100%;
            padding-right: 45px; /* space for icon */
        }

        .toggle-password {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #45f3ff;
            cursor: pointer;
            font-size: 1.1em;
            transition: 0.3s;
        }

            .toggle-password:hover {
                color: #ff2770;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="box">
        <div class="login">

            <asp:Panel ID="pnlLogin" runat="server" CssClass="loginBx">

                <h2>
                    <i class="fa-solid fa-right-to-bracket"></i>
                    Login
                <i class="fa-solid fa-heart"></i>
                </h2>

                <asp:TextBox
                    ID="txtUsername" runat="server" Placeholder="Username" />

                <div class="password-wrap">
                    <asp:TextBox
                        ID="txtPassword"
                        runat="server"
                        TextMode="Password"
                        Placeholder="Password"
                        CssClass="password-input" />

                    <i class="fa-solid fa-eye toggle-password"
                        onclick="togglePassword('<%= txtPassword.ClientID %>', this)"></i>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" onclick="btnLogin_Click"/>

                <div class="group">
                    <asp:HyperLink runat="server" NavigateUrl="ForgotPassword.aspx">
                    Forgot Password
                    </asp:HyperLink>

                    <asp:HyperLink runat="server" NavigateUrl="AdminSignup.aspx">
                    Sign up
                    </asp:HyperLink>
                </div>

                <asp:Label
                    ID="lblMessage"
                    runat="server"
                    CssClass="text-danger" />

            </asp:Panel>

        </div>
    </div>
    <script>
        function togglePassword(inputId, icon) {
            const input = document.getElementById(inputId);

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
