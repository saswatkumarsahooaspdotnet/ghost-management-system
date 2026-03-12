<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CardPagePerState.aspx.cs" Inherits="ghost_series.CardPagePerState" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: #0f0f0f;
            background-image: radial-gradient(circle, #1a1a1a 0%, #050505 100%);
            color: #e0e0e0;
            font-family: 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            padding-bottom: 50px;
        }

        .ghost-card {
            background: rgba(26, 26, 26, 0.9);
            border: 1px solid #333;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.4s ease;
            color: #fff;
            height: 100%;
        }

            .ghost-card:hover {
                box-shadow: 0 0 25px rgba(255, 0, 0, 0.5);
                border-color: #ff4d4d;
                transform: translateY(-5px);
            }

        .ghost-img-container {
            height: 220px;
            overflow: hidden;
            position: relative;
            background-color: #000;
        }

            .ghost-img-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                filter: grayscale(50%) contrast(110%);
                transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94), filter 0.6s ease;
            }

        .ghost-card:hover .ghost-img-container img {
            transform: scale(1.1);
            filter: grayscale(0%) contrast(120%);
        }

        .card-title {
            color: #ff4d4d;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            font-size: 1.4rem;
        }

        .text-muted {
            color: #0dcaf0 !important;
        }

        .state-header {
            color: #0dcaf0;
            text-transform: uppercase;
            letter-spacing: 5px;
            margin-top: 30px;
            text-shadow: 0 0 10px rgba(13, 202, 240, 0.5);
        }

        .typewriter-text {
            overflow: hidden;
            border-right: .15em solid var(--ghost-cyan); /* The "cursor" */
            white-space: normal;
            margin: 0 auto;
            letter-spacing: 0.05em;
        }

        @keyframes blink-caret {
            from, to {
                border-color: transparent
            }

            50% {
                border-color: var(--ghost-cyan);
            }
        }

        .cursor-active {
            animation: blink-caret .75s step-end infinite;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center">
                <h1 class="state-header mb-5">
                    <asp:Literal ID="litStateName" runat="server"></asp:Literal>
                    Surveillance Records
                </h1>
            </div>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="rptGhostCards" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4">
                        <div class="card ghost-card shadow-lg">
                            <div class="ghost-img-container">
                                <img src='<%# ResolveUrl(Convert.ToString(Eval("ImageUrl"))) %>'
                                     class="card-img-top"
                                     alt='<%# Eval("PlaceName") %>' />
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h4 class="card-title fw-bold text-uppercase mb-1"><%# Eval("PlaceName") %></h4>
                                <p class="small text-muted mb-3">
                                    <i class="bi bi-geo-alt-fill"></i><%# Eval("State") %>
                                </p>
                                <p class="card-text text-secondary flex-grow-1 typewriter-text" data-text='<%# Eval("ShortSummary") %>'></p>
                                <div class="mt-3">
                                    <a href='Details.aspx?ID=<%# Eval("PlaceId") %>' class="btn btn-outline-danger btn-sm w-100 fw-bold">VIEW DOSSIER</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="text-center mt-5">
            <h3 class="text-secondary">No paranormal activity detected in this sector.</h3>
            <a href="Home.aspx" class="btn btn-info mt-3">Return to Map</a>
        </asp:Panel>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const typewriters = document.querySelectorAll('.typewriter-text');

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const element = entry.target;
                        const text = element.getAttribute('data-text');
                        element.classList.add('cursor-active');
                        typeWriter(element, text, 0);

                        observer.unobserve(element);
                    }
                });
            }, { threshold: 0.5 });

            typewriters.forEach(tw => observer.observe(tw));

            function typeWriter(element, text, i) {
                if (i < text.length) {
                    element.innerHTML += text.charAt(i);
                    setTimeout(() => typeWriter(element, text, i + 1), 30);
                } else {
                    setTimeout(() => element.classList.remove('cursor-active'), 2000);
                }
            }
        });
    </script>
</asp:Content>
