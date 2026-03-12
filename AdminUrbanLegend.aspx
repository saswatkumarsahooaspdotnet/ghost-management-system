<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AdminUrbanLegend.aspx.cs" Inherits="ghost_series.AdminUrbanLegend" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-box {
            background: rgba(0,0,0,.15);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,.15);
            margin-bottom: 25px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
        }

        .btn {
            padding: 8px 15px;
            margin-right: 5px;
        }

        .action-col {
            white-space: nowrap;
            width: 160px;
            text-align: center;
        }

        #gvLegends {
            width: 100%;
            border-collapse: collapse;
        }

            #gvLegends th, #gvLegends td {
                padding: 10px 12px;
                vertical-align: middle;
            }

            #gvLegends th {
                text-align: left;
                background: #f5f5f5;
                font-weight: 600;
            }

        .animated-welcome {
            font-weight: bold;
            text-align: center;
            animation: ghostStyleChange 10s infinite;
        }

        @keyframes ghostStyleChange {
            0%, 20%   { color: cadetblue; font-family: 'Segoe UI', sans-serif; }
            21%, 40%  { color: #0dcaf0; font-family: 'Courier New', monospace; text-shadow: 0 0 10px #0dcaf0; }
            41%, 60%  { color: #ff00ff; font-family: 'Georgia', serif; }
            61%, 80%  { color: #7ef9ff; font-family: 'Impact', sans-serif; letter-spacing: 2px; }
            81%, 100% { color: #ffffff; font-family: 'Comic Sans MS', cursive; text-shadow: 2px 2px 5px #0dcaf0; }
        }

        .section-subheader {
            border-left: 3px solid #0dcaf0;
            padding-left: 10px;
            margin: 20px 0 10px 0;
            color: #0dcaf0;
            font-size: 1rem;
            font-family: 'Courier New', monospace;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .tag-item {
            background: black;
            border: 1px solid #333;
            padding: 8px 12px;
            margin-bottom: 6px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }

            .tag-item:hover {
                border-color: #0dcaf0;
            }

        .tag-item span {
            color: #e0e0e0;
            font-size: 0.9rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <center>
        <h1>
            <asp:Label ID="lblSession" class="animated-welcome" runat="server" Text="Urban Legend Admin Panel"></asp:Label>
        </h1>
    </center>

    <div class="admin-box">
        <h3>Add / Edit Urban Legend</h3>

        <asp:HiddenField ID="hfLegendId" runat="server" />

        <div class="container-fluid">

            <!--  Legend Name & Place Name  -->
            <div class="row">
                <div class="col-md-6">
                    <asp:Label runat="server" Text="Legend Name :" Style="font-weight:bold;font-size:15px" class="section-subheader"/>
                    <asp:TextBox ID="txtLegendName" runat="server" CssClass="form-control" Placeholder="e.g. Nale Ba, Churail" />
                </div>
                <div class="col-md-6">
                    <asp:Label runat="server" Text="Place Name :" Style="font-weight:bold;font-size:15px" class="section-subheader"/>
                    <asp:TextBox ID="txtPlaceName" runat="server" CssClass="form-control" Placeholder="e.g. Karnataka, India" />
                </div>
            </div>

            <!--  APPEARANCE  -->
            <div class="section-subheader"><i class="fas fa-eye me-2"></i>Appearance</div>
            <div class="row">
                <div class="col-md-11">
                    <asp:TextBox ID="txtAppearance" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Placeholder="Describe physical appearance..." />
                    <asp:HiddenField ID="hfSelectedAppearanceIndex" runat="server" Value="-1" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddAppearance" runat="server" Text="Add"
                        CssClass="btn btn-outline-success" style="margin-top:12px"
                        OnClientClick="addAppearance(); return false;" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div id="appearanceContainer" class="mt-2"></div>
                </div>
            </div>

            <!-- ABILITIES  -->
            <div class="section-subheader"><i class="fas fa-bolt me-2"></i>Abilities</div>
            <div class="row">
                <div class="col-md-11">
                    <asp:TextBox ID="txtAbility" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Placeholder="e.g. Shapeshifting, Invisibility, Mind Control..." />
                    <asp:HiddenField ID="hfSelectedAbilityIndex" runat="server" Value="-1" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddAbility" runat="server" Text="Add"
                        CssClass="btn btn-outline-success" style="margin-top:12px"
                        OnClientClick="addAbility(); return false;" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div id="abilitiesContainer" class="mt-2"></div>
                </div>
            </div>

            <!--  SIGHTINGS  -->
            <div class="section-subheader"><i class="fas fa-skull-crossbones me-2"></i>Sightings</div>
            <div class="row">
                <div class="col-md-11">
                    <asp:TextBox ID="txtSighting" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Placeholder="Describe a sighting or paranormal claim..." />
                    <asp:HiddenField ID="hfSelectedSightingIndex" runat="server" Value="-1" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddSighting" runat="server" Text="Add"
                        CssClass="btn btn-outline-success" style="margin-top:12px"
                        OnClientClick="addSighting(); return false;" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div id="sightingsContainer" class="mt-2"></div>
                </div>
            </div>

            <!-- THEORIES  -->
            <div class="section-subheader"><i class="fas fa-flask me-2"></i>Explanations & Theories</div>
            <div class="row">
                <div class="col-md-11">
                    <asp:TextBox ID="txtTheory" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Placeholder="Enter an explanation or theory..." />
                    <asp:HiddenField ID="hfSelectedTheoryIndex" runat="server" Value="-1" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddTheory" runat="server" Text="Add"
                        CssClass="btn btn-outline-success" style="margin-top:12px"
                        OnClientClick="addTheory(); return false;" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div id="theoriesContainer" class="mt-2"></div>
                </div>
            </div>

            <!--  IMAGES  -->
            <div class="section-subheader"><i class="fas fa-images me-2"></i>Images</div>
            <div class="row">
                <div class="col-md-11">
                    <asp:Label runat="server" Text="Upload Image :" Style="font-weight:bold;font-size:15px" />
                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                    <asp:HiddenField ID="hfImagePath" runat="server" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddImage" runat="server" Text="Add"
                        CssClass="btn btn-outline-success" style="margin-top:24px"
                        OnClientClick="addImage(); return false;" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div id="imagesContainer" class="mt-2"></div>
                </div>
            </div>

            <!-- Active & Buttons -->
            <div class="mt-3">
                <asp:CheckBox ID="chkActive" runat="server" Text="  Is Active" Checked="true" />
                <br /><br />
                <asp:Button ID="btnSave"  runat="server" Text="Save"  CssClass="btn btn-outline-success" OnClick="btnSave_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-info" OnClick="btnClear_Click" />
            </div>

        </div>
    </div>

    <div class="admin-box">
        <h3>Urban Legends List</h3>

        <asp:GridView ID="gvLegends" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="LegendId"
            ClientIDMode="Static"
            HorizontalAlign="Center"
            CssClass="table table-striped table-bordered"
            OnRowCommand="gvLegends_RowCommand">
            <Columns>
                <asp:BoundField DataField="LegendId" HeaderText="ID" />
                <asp:BoundField DataField="LegendName" HeaderText="Legend Name" />
                <asp:BoundField DataField="PlaceName" HeaderText="Place" />
                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="action-col">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server"
                            Text="Edit" CssClass="btn btn-warning btn-sm"
                            CommandName="EditRow"
                            CommandArgument='<%# Eval("LegendId") %>' />
                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete" CssClass="btn btn-danger btn-sm"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("LegendId") %>'
                            OnClientClick="return confirm('Are you sure you want to delete this legend?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <script>

        /* ── APPEARANCE ── */
        function addAppearance() {
            let val = document.getElementById('<%=txtAppearance.ClientID%>').value;
            let idx = parseInt(document.getElementById('<%=hfSelectedAppearanceIndex.ClientID%>').value);
            if (!val) return;
            fetch("AdminUrbanLegend.aspx/AddAppearance", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ text: val, index: idx })
            }).then(r => r.json()).then(d => {
                renderList(d.d, "appearanceContainer", "deleteAppearance", "selectAppearance");
                document.getElementById('<%=txtAppearance.ClientID%>').value = "";
                document.getElementById('<%=hfSelectedAppearanceIndex.ClientID%>').value = -1;
            });
        }
        function deleteAppearance(i) {
            fetch("AdminUrbanLegend.aspx/DeleteAppearance", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            }).then(r => r.json()).then(d => renderList(d.d, "appearanceContainer", "deleteAppearance", "selectAppearance"));
        }
        function selectAppearance(i, text) {
            document.getElementById('<%=txtAppearance.ClientID%>').value = text;
            document.getElementById('<%=hfSelectedAppearanceIndex.ClientID%>').value = i;
        }

        /* ── ABILITIES ── */
        function addAbility() {
            let val = document.getElementById('<%=txtAbility.ClientID%>').value;
            let idx = parseInt(document.getElementById('<%=hfSelectedAbilityIndex.ClientID%>').value);
            if (!val) return;
            fetch("AdminUrbanLegend.aspx/AddAbility", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ text: val, index: idx })
            }).then(r => r.json()).then(d => {
                renderList(d.d, "abilitiesContainer", "deleteAbility", "selectAbility");
                document.getElementById('<%=txtAbility.ClientID%>').value = "";
                document.getElementById('<%=hfSelectedAbilityIndex.ClientID%>').value = -1;
            });
        }
        function deleteAbility(i) {
            fetch("AdminUrbanLegend.aspx/DeleteAbility", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            }).then(r => r.json()).then(d => renderList(d.d, "abilitiesContainer", "deleteAbility", "selectAbility"));
        }
        function selectAbility(i, text) {
            document.getElementById('<%=txtAbility.ClientID%>').value = text;
            document.getElementById('<%=hfSelectedAbilityIndex.ClientID%>').value = i;
        }

        /* ── SIGHTINGS ── */
        function addSighting() {
            let val = document.getElementById('<%=txtSighting.ClientID%>').value;
            let idx = parseInt(document.getElementById('<%=hfSelectedSightingIndex.ClientID%>').value);
            if (!val) return;
            fetch("AdminUrbanLegend.aspx/AddSighting", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ text: val, index: idx })
            }).then(r => r.json()).then(d => {
                renderList(d.d, "sightingsContainer", "deleteSighting", "selectSighting");
                document.getElementById('<%=txtSighting.ClientID%>').value = "";
                document.getElementById('<%=hfSelectedSightingIndex.ClientID%>').value = -1;
            });
        }
        function deleteSighting(i) {
            fetch("AdminUrbanLegend.aspx/DeleteSighting", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            }).then(r => r.json()).then(d => renderList(d.d, "sightingsContainer", "deleteSighting", "selectSighting"));
        }
        function selectSighting(i, text) {
            document.getElementById('<%=txtSighting.ClientID%>').value = text;
            document.getElementById('<%=hfSelectedSightingIndex.ClientID%>').value = i;
        }

        /* ── THEORIES ── */
        function addTheory() {
            let val = document.getElementById('<%=txtTheory.ClientID%>').value;
            let idx = parseInt(document.getElementById('<%=hfSelectedTheoryIndex.ClientID%>').value);
            if (!val) return;
            fetch("AdminUrbanLegend.aspx/AddTheory", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ text: val, index: idx })
            }).then(r => r.json()).then(d => {
                renderList(d.d, "theoriesContainer", "deleteTheory", "selectTheory");
                document.getElementById('<%=txtTheory.ClientID%>').value = "";
                document.getElementById('<%=hfSelectedTheoryIndex.ClientID%>').value = -1;
            });
        }
        function deleteTheory(i) {
            fetch("AdminUrbanLegend.aspx/DeleteTheory", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            }).then(r => r.json()).then(d => renderList(d.d, "theoriesContainer", "deleteTheory", "selectTheory"));
        }
        function selectTheory(i, text) {
            document.getElementById('<%=txtTheory.ClientID%>').value = text;
            document.getElementById('<%=hfSelectedTheoryIndex.ClientID%>').value = i;
        }

        /* ── IMAGES ── */
        function addImage() {
            let fileInput = document.getElementById('<%=fuImage.ClientID%>');
            let file = fileInput.files[0];
            if (!file) return;
            let formData = new FormData();
            formData.append("file", file);
            fetch("UploadHandler.ashx", { method: "POST", body: formData })
                .then(r => r.text())
                .then(path => {
                    fetch("AdminUrbanLegend.aspx/AddImage", {
                        method: "POST", headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ imagePath: path })
                    }).then(r => r.json()).then(d => renderImages(d.d));
                    fileInput.value = "";
                });
        }
        function deleteImage(i) {
            fetch("AdminUrbanLegend.aspx/DeleteImage", {
                method: "POST", headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            }).then(r => r.json()).then(d => renderImages(d.d));
        }
        function renderImages(list) {
            let html = "";
            list.forEach((path, i) => {
                html += `
                <div style="display:inline-block;position:relative;margin:3px;">
                    <img src="${path}" style="height:80px;border-radius:6px;" />
                    <button onclick="deleteImage(${i})" type="button"
                        style="position:absolute;top:-6px;right:-6px;background:red;color:white;
                               border:none;border-radius:50%;width:22px;height:22px;">✕</button>
                </div>`;
            });
            document.getElementById("imagesContainer").innerHTML = html;
        }

        /* ── SHARED RENDER for text lists ── */
        function renderList(list, containerId, deleteFn, selectFn) {
            let html = "";
            list.forEach((item, i) => {
                html += `
                <div class="tag-item"
                     onclick="${selectFn}(${i}, \`${item.replace(/`/g, '\\`')}\`)">
                    <span>${item}</span>
                    <button class="btn btn-sm btn-danger" type="button"
                        onclick="event.stopPropagation(); ${deleteFn}(${i})">✕</button>
                </div>`;
            });
            document.getElementById(containerId).innerHTML = html;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
