<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="ghost_series.Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dossier-header {
            border-left: 4px solid var(--ghost-red);
            padding-left: 20px;
            margin-bottom: 30px;
        }

        .main-place-img {
            width: 100%;
            max-height: 450px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .data-label {
            color: var(--ghost-cyan);
            font-family: 'Courier New', Courier, monospace;
            font-weight: bold;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .era-text {
            font-size: 0.9rem;
            color: #ccc;
        }

        .claim-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid #222;
            border-left: 3px solid var(--ghost-red);
            padding: 12px 18px;
            margin-bottom: 12px;
            border-radius: 4px;
            font-size: 0.95rem;
        }

        .video-evidence-card {
            background: #111;
            border: 1px solid #333;
            border-radius: 8px;
            padding: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
        }

            .video-evidence-card:hover {
                border-color: var(--ghost-cyan);
                box-shadow: 0 0 20px rgba(13, 202, 240, 0.2);
            }

        /* Smaller, cleaner container */
        .compact-video-container {
            position: relative;
            padding-bottom: 56.25%; /* Keeps 16:9 ratio but controlled by parent col size */
            height: 0;
            overflow: hidden;
            border-radius: 4px;
            background: #000;
        }

            .compact-video-container iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
            }

        /* Detail labels for the video card */
        .video-header {
            display: flex;
            justify-content: space-between;
            padding-bottom: 8px;
        }

        .tiny-label {
            font-family: 'Courier New', monospace;
            font-size: 0.65rem;
            color: #888;
        }

        .video-footer {
            padding-top: 8px;
            border-top: 1px solid #222;
            margin-top: 8px;
        }

        .file-path {
            font-family: 'Courier New', monospace;
            font-size: 0.6rem;
            color: var(--ghost-cyan);
            opacity: 0.7;
        }

        /* Recording blink animation */
        .blink {
            animation: rec-blink 1.5s infinite;
        }

        @keyframes rec-blink {
            0%, 100% {
                opacity: 1;
            }

            50% {
                opacity: 0;
            }
        }

        .section-divider {
            border-top: 1px solid #333;
            margin: 40px 0;
        }
        /* Lightbox Overlay */
        #lightbox {
            display: none;
            position: fixed;
            z-index: 9999;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.9);
            justify-content: center;
            align-items: center;
            cursor: zoom-out;
        }

        #lightbox-img {
            max-width: 90%;
            max-height: 90%;
            border: 2px solid #444;
            box-shadow: 0 0 30px rgba(0,0,0,0.8);
            transition: transform 0.3s ease;
        }

        .close-btn {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Home.aspx" class="text-info">Map</a></li>
                <li class="breadcrumb-item active text-secondary" aria-current="page">Dossier</li>
            </ol>
        </nav>

        <div class="row mt-4">
            <div class="col-lg-5 mb-4">
                <asp:Image ID="imgMain" runat="server" CssClass="main-place-img shadow" />

                <div class="mt-4 p-4 bg-dark bg-opacity-50 border border-secondary rounded-3">
                    <div class="row">
                        <div class="col-6 mb-3">
                            <span class="data-label d-block">Location ID</span>
                            <span class="text-white">#<asp:Literal ID="litPlaceId" runat="server" /></span>
                        </div>
                        <div class="col-6 mb-3">
                            <span class="data-label d-block">Territory</span>
                            <span class="text-white">
                                <asp:Literal ID="litState" runat="server" /></span>
                        </div>
                        <div class="col-12">
                            <span class="data-label d-block">Era Detected</span>
                            <span class="text-white-15">
                                <asp:Literal ID="litPeriod" runat="server" /></span>
                        </div>
                        <div class="col-12 mt-3">
                            <asp:Repeater ID="rptImages" runat="server">
                                <ItemTemplate>
                                    <img src='<%# ResolveUrl(Convert.ToString(Eval("ImageUrl"))) %>'
                                        onclick="openLightbox(this.src)"
                                        style="width: 100%; max-height: 250px; object-fit: cover; border-radius: 6px; margin-bottom: 8px; border: 1px solid #333; cursor: pointer;" />
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <%--<div class="col-6 text-end">
                            <span class="badge bg-danger p-2 px-3 shadow" >RESTRICTED ACCESS</span>
                        </div>--%>
                    </div>
                </div>
            </div>

            <div class="col-lg-7 px-lg-5">
                <div class="dossier-header">
                    <h1 class="fw-bold" style="color: var(--ghost-cyan); letter-spacing: -1px;">
                        <asp:Literal ID="litPlaceName" runat="server" />
                    </h1>
                    <p class="text-info small mb-0 font-monospace text-uppercase">Sub-Sector Verified</p>
                </div>

                <div class="mb-4">
                    <h6 class="data-label"><i class="fas fa-microchip me-2"></i>Summary Information</h6>
                    <p class="text-white-15">
                        <asp:Literal ID="litShortSummary" runat="server" />
                    </p>
                </div>

                <div class="mb-4">
                    <h6 class="data-label"><i class="fas fa-scroll me-2"></i>Historical Description</h6>
                    <p class="text-white-15" style="line-height: 1.6;">
                        <asp:Literal ID="litDescription" runat="server" />
                    </p>
                </div>

                <div class="section-divider"></div>

                <div>
                    <h6 class="data-label mb-3"><i class="fas fa-skull-crossbones me-2"></i>Sightings & Paranormal Claims</h6>
                    <asp:Repeater ID="rptClaims" runat="server">
                        <ItemTemplate>
                            <div class="claim-card">
                                <span class="text-light"><%# Eval("ClaimDescription") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:PlaceHolder ID="plcLocation" runat="server">
                    <div class="col-12 mt-4">
                        <h6 class="data-label mb-2">
                            <i class="fas fa-map-marked-alt me-2"></i>Location Coordinates
                        </h6>

                        <div style="width: 100%; height: 260px; border-radius: 10px; overflow: hidden; border: 1px solid #333;">
                            <asp:Literal ID="litMap" runat="server"></asp:Literal>
                        </div>
                    </div>
                </asp:PlaceHolder>

            </div>
        </div>
        <asp:PlaceHolder ID="plcYtLinks" runat="server">
            <div class="row mt-5 justify-content-center">
                <div class="col-12 text-center mb-4">
                    <h6 class="data-label"><i class="fab fa-youtube me-2"></i>RECONNAISSANCE FOOTAGE</h6>
                    <div style="width: 50px; height: 2px; background: var(--ghost-red); margin: 10px auto;"></div>
                </div>

                <asp:Repeater ID="rptVideos" runat="server">
                    <ItemTemplate>
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="video-evidence-card">
                                <div class="video-header">
                                    <span class="tiny-label"><i class="fas fa-circle text-danger blink me-1"></i>REC 0<%# Container.ItemIndex + 1 %></span>
                                </div>
                                <div class="compact-video-container">
                                    <iframe src='<%# Eval("YtUrl") %>'
                                        frameborder="0"
                                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                        allowfullscreen></iframe>
                                </div>
                                <div class="video-footer">
                                    <span class="file-path">FILE_TYPE: YT</span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:PlaceHolder ID="phNoVideos" runat="server" Visible="false">
                    <div class="col-12 text-center py-4 border border-secondary border-dashed">
                        <p class="text-secondary small mb-0 font-monospace">NO VISUAL DATA ARCHIVED FOR THIS SECTOR</p>
                    </div>
                </asp:PlaceHolder>
            </div>
        </asp:PlaceHolder>

    </div>
    <div id="lightbox" onclick="closeLightbox()">
        <span class="close-btn">&times;</span>
        <img id="lightbox-img" src="" alt="Full Screen Preview" />
    </div>
    <script>
        function openLightbox(src) {
            const lb = document.getElementById('lightbox');
            const lbImg = document.getElementById('lightbox-img');
            lbImg.src = src;
            lb.style.display = 'flex';
            // Prevent scrolling while open
            document.body.style.overflow = 'hidden';
        }

        function closeLightbox() {
            document.getElementById('lightbox').style.display = 'none';
            // Restore scrolling
            document.body.style.overflow = 'auto';
        }
    </script>
</asp:Content>
