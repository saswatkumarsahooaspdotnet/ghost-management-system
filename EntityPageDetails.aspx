<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="EntityPageDetails.aspx.cs" Inherits="ghost_series.EntityPageDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: #0f0f0f;
            background-image: radial-gradient(circle, #1a1a1a 0%, #050505 100%);
            color: #e0e0e0;
            font-family: 'Segoe UI', Roboto, sans-serif;
        }

        /* ── DOSSIER HEADER ── */
        .dossier-header {
            border-left: 4px solid var(--ghost-red);
            padding-left: 20px;
            margin-bottom: 30px;
        }

        /* ── MAIN CIRCULAR IMAGE ── */
        .legend-img-container {
            width: 200px;
            height: 200px;
            overflow: hidden;
            border-radius: 50%;
            border: 3px solid #ff4d4d;
            margin: 0 auto 20px auto;
            box-shadow: 0 0 25px rgba(255, 0, 0, 0.5);
        }

            .legend-img-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                object-position: center top;
                filter: grayscale(40%) contrast(115%);
                transition: transform 0.6s ease, filter 0.5s ease;
            }

            .legend-img-container:hover img {
                transform: scale(1.1);
                filter: grayscale(0%) contrast(125%);
            }

        /* ── DATA LABELS ── */
        .data-label {
            color: var(--ghost-cyan);
            font-family: 'Courier New', Courier, monospace;
            font-weight: bold;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* ── SECTION PANEL ── */
        .section-panel {
            background: rgba(26, 26, 26, 0.85);
            border: 1px solid #222;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 28px;
        }

        .section-panel-red {
            border-left: 4px solid var(--ghost-red);
        }

        .section-panel-cyan {
            border-left: 4px solid var(--ghost-cyan);
        }

        .section-panel-yellow {
            border-left: 4px solid #ffc107;
        }

        .section-panel-purple {
            border-left: 4px solid #9b59b6;
        }

        /* ── CLAIM CARDS ── */
        .claim-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid #222;
            border-left: 3px solid var(--ghost-red);
            padding: 12px 18px;
            margin-bottom: 12px;
            border-radius: 4px;
            font-size: 0.95rem;
        }

        .ability-card {
            background: rgba(13, 202, 240, 0.05);
            border: 1px solid #1a3a3a;
            border-left: 3px solid var(--ghost-cyan);
            padding: 12px 18px;
            margin-bottom: 12px;
            border-radius: 4px;
            font-size: 0.95rem;
        }

        .theory-card {
            background: rgba(155, 89, 182, 0.05);
            border: 1px solid #2a1a3a;
            border-left: 3px solid #9b59b6;
            padding: 14px 18px;
            margin-bottom: 12px;
            border-radius: 4px;
            font-size: 0.95rem;
        }

        /* ── GALLERY ── */
        .gallery-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #333;
            filter: grayscale(30%);
            transition: all 0.4s ease;
            cursor: pointer;
        }

            .gallery-img:hover {
                filter: grayscale(0%);
                border-color: #ff4d4d;
                box-shadow: 0 0 15px rgba(255, 0, 0, 0.4);
                transform: scale(1.03);
            }

        /* ── SECTION DIVIDER ── */
        .section-divider {
            border-top: 1px solid #2a2a2a;
            margin: 35px 0;
        }

        /* ── BADGE ── */
        .legend-badge {
            font-family: 'Courier New', monospace;
            font-size: 0.7rem;
            background: rgba(255, 77, 77, 0.15);
            border: 1px solid #ff4d4d;
            color: #ff4d4d;
            padding: 4px 10px;
            border-radius: 4px;
            letter-spacing: 1px;
        }

        /* ── NO DATA ── */
        .no-data-text {
            color: #444;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
        }

        /* ── LIGHTBOX OVERLAY ── */
        #lightbox {
            display: none;
            position: fixed;
            z-index: 9999;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.92);
            justify-content: center;
            align-items: center;
        }

            #lightbox img {
                max-width: 85vw;
                max-height: 85vh;
                border-radius: 10px;
                border: 2px solid #ff4d4d;
                box-shadow: 0 0 40px rgba(255,0,0,0.4);
            }

        #lightbox-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: #fff;
            font-size: 2rem;
            cursor: pointer;
            font-family: monospace;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">

        <!-- BREADCRUMB -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Home.aspx" class="text-info">Map</a></li>
                <li class="breadcrumb-item"><a href="EntityPage.aspx" class="text-info">Legends</a></li>
                <li class="breadcrumb-item active text-secondary" aria-current="page">Dossier</li>
            </ol>
        </nav>
        <div class="row mt-4">

            <div class="col-lg-4 mb-4 text-center">
                <div class="legend-img-container">
                    <asp:Image ID="imgPortrait" runat="server" />
                </div>

                <span class="legend-badge mb-3 d-inline-block">ENTITY ON RECORD</span>

                <div class="mt-3 p-4 bg-dark bg-opacity-50 border border-secondary rounded-3 text-start">
                    <div class="row">
                        <div class="col-6 mb-3">
                            <span class="data-label d-block">Legend ID</span>
                            <span class="text-white">#<asp:Literal ID="litLegendId" runat="server" /></span>
                        </div>
                        <div class="col-6 mb-3">
                            <span class="data-label d-block">Location</span>
                            <span class="text-white">
                                <asp:Literal ID="litPlaceName" runat="server" /></span>
                        </div>
                        <div class="col-12">
                            <span class="data-label d-block">Status</span>
                            <span class="text-danger fw-bold font-monospace">⬤ ACTIVE THREAT</span>
                        </div>
                    </div>
                </div>

                <div class="mt-4 text-start">
                    <h6 class="data-label mb-3"><i class="fas fa-images me-2"></i>Image Archive</h6>
                    <div class="row g-2">
                        <asp:Repeater ID="rptGallery" runat="server">
                            <ItemTemplate>
                                <div class="col-6">
                                    <img src='<%# ResolveUrl(Convert.ToString(Eval("ImageUrl"))) %>'
                                         class="gallery-img"
                                         alt="Evidence"
                                         onclick="openLightbox(this.src)" />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlNoImages" runat="server" Visible="false" CssClass="col-12">
                            <p class="no-data-text mt-2">// NO IMAGES ARCHIVED</p>
                        </asp:Panel>
                    </div>
                </div>

            </div>

            <div class="col-lg-8 px-lg-4">

                <div class="dossier-header mb-4">
                    <h1 class="fw-bold" style="color: var(--ghost-cyan); letter-spacing: -1px;">
                        <asp:Literal ID="litLegendName" runat="server" />
                    </h1>
                    <p class="text-info small mb-0 font-monospace text-uppercase">Entity Classification — Verified</p>
                </div>

                <div class="section-panel section-panel-red mb-4">
                    <h6 class="data-label mb-3"><i class="fas fa-eye me-2"></i>Appearance</h6>
                    <asp:Repeater ID="rptAppearance" runat="server">
                        <ItemTemplate>
                            <p class="text-white mb-2" style="line-height: 1.7;">
                                <%# Eval("Appearance") %>
                            </p>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoAppearance" runat="server" Visible="false">
                        <p class="no-data-text">// NO APPEARANCE DATA ON FILE</p>
                    </asp:Panel>
                </div>

                <div class="section-panel section-panel-cyan mb-4">
                    <h6 class="data-label mb-3"><i class="fas fa-bolt me-2"></i>Abilities</h6>
                    <asp:Repeater ID="rptAbilities" runat="server">
                        <ItemTemplate>
                            <div class="ability-card">
                                <span class="text-info"><%# Eval("AbilityName") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoAbilities" runat="server" Visible="false">
                        <p class="no-data-text">// NO ABILITY DATA ON FILE</p>
                    </asp:Panel>
                </div>

            </div>
        </div>

        <div class="section-divider"></div>
        <div class="row">
            <div class="col-12">
                <div class="section-panel section-panel-red">
                    <h6 class="data-label mb-3">
                        <i class="fas fa-skull-crossbones me-2"></i>Sightings & Paranormal Claims
                </h6>
                    <asp:Repeater ID="rptSightings" runat="server">
                        <ItemTemplate>
                            <div class="claim-card">
                                <span class="text-light"><%# Eval("SightingDescription") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoSightings" runat="server" Visible="false">
                        <p class="no-data-text">// NO SIGHTINGS RECORDED IN DATABASE</p>
                    </asp:Panel>
                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <div class="row">
            <div class="col-12">
                <div class="section-panel section-panel-purple">
                    <h6 class="data-label mb-3">
                        <i class="fas fa-flask me-2"></i>Explanations & Theories
                </h6>
                    <asp:Repeater ID="rptTheories" runat="server">
                        <ItemTemplate>
                            <div class="theory-card">
                                <span class="text-light"><%# Eval("TheoriesDescription") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoTheories" runat="server" Visible="false">
                        <p class="no-data-text">// NO THEORIES FILED</p>
                    </asp:Panel>
                </div>
            </div>
        </div>

        <div class="text-center mt-4">
            <a href="EntityPage.aspx" class="btn btn-outline-danger px-5 fw-bold font-monospace">← RETURN TO RECORDS
        </a>
        </div>

    </div>

    <div id="lightbox" onclick="closeLightbox()">
        <span id="lightbox-close" onclick="closeLightbox()">✕</span>
        <img id="lightbox-img" src="#" alt="Enlarged Evidence" />
    </div>

    <script>
        function openLightbox(src) {
            document.getElementById('lightbox-img').src = src;
            document.getElementById('lightbox').style.display = 'flex';
        }
        function closeLightbox() {
            document.getElementById('lightbox').style.display = 'none';
        }
</script>
</asp:Content>
