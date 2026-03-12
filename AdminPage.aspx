<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AdminPage.aspx.cs" Inherits="ghost_series.AdminPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-box {
            background: rgba(0,0,0,.15);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,.15);
            margin-bottom: 25px;
        }

        .filters {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

            .filters select {
                padding: 8px;
                width: 220px;
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
        /* GridView fixes */
        #gvPlaces {
            width: 100%;
            border-collapse: collapse;
        }

            #gvPlaces th,
            #gvPlaces td {
                padding: 10px 12px;
                vertical-align: middle;
            }

        /* Prevent wrapping in Action column */
        .action-col {
            white-space: nowrap;
            width: 160px;
            text-align: center;
        }

        /* Keep buttons in one line */
        .action-btns {
            display: flex;
            gap: 8px;
            justify-content: center;
            align-items: center;
        }

            .action-btns .btn {
                padding: 4px 12px;
                font-size: 13px;
            }

        #gvPlaces th {
            text-align: left;
            background: #f5f5f5;
            font-weight: 600;
        }

        .fulldesc {
            max-height: 100px;
            display: block;
        }

        .animated-welcome {
            font-weight: bold;
            text-align: center;
            text-decoration: dotted;
            /* Animation Name | Duration | Timing | Iteration */
            animation: ghostStyleChange 10s infinite;
        }

        @keyframes ghostStyleChange {
            0%, 20% {
                color: cadetblue;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            21%, 40% {
                color: #0dcaf0; /* Cyan */
                font-family: 'Courier New', Courier, monospace;
                text-shadow: 0 0 10px #0dcaf0;
            }

            41%, 60% {
                color: #ff00ff; /* Magenta */
                font-family: 'Georgia', serif;
            }

            61%, 80% {
                color: #7ef9ff; /* Electric Blue */
                font-family: 'Impact', Charcoal, sans-serif;
                letter-spacing: 2px;
            }

            81%, 100% {
                color: #ffffff; /* White Glow */
                font-family: 'Comic Sans MS', cursive;
                text-shadow: 2px 2px 5px #0dcaf0;
            }
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <center>
        <h1>
            <asp:Label ID="lblSession" class="animated-welcome" runat="server" Text="Welcome Admin"></asp:Label>
        </h1>
    </center>
    <div class="admin-box">
        <h3>Add / Edit Ghost Place</h3>

        <asp:HiddenField ID="hfPlaceID" runat="server" />
        <div class="container-fluid">
            <%--State & Place Name--%>
            <div class="row">
                <div class="col-md-4">
                    <asp:Label ID="lblState" runat="server" Text="Choose State :" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px"></asp:Label>
                    <asp:DropDownList ID="ddlAddState" runat="server" CssClass="form-control">
                        <asp:ListItem>Andhra Pradesh</asp:ListItem>
                        <asp:ListItem>Arunanchal Pradesh</asp:ListItem>
                        <asp:ListItem>Assam</asp:ListItem>
                        <asp:ListItem>Bihar</asp:ListItem>
                        <asp:ListItem>Chhatisgarh</asp:ListItem>
                        <asp:ListItem>Goa</asp:ListItem>
                        <asp:ListItem>Gujarat</asp:ListItem>
                        <asp:ListItem>Haryana</asp:ListItem>
                        <asp:ListItem>Himachal Pradesh</asp:ListItem>
                        <asp:ListItem>Jharkhand</asp:ListItem>
                        <asp:ListItem>Karnataka</asp:ListItem>
                        <asp:ListItem>Kerala</asp:ListItem>
                        <asp:ListItem>Madhya Pradesh</asp:ListItem>
                        <asp:ListItem>Maharastra</asp:ListItem>
                        <asp:ListItem>Manipur</asp:ListItem>
                        <asp:ListItem>Meghalaya</asp:ListItem>
                        <asp:ListItem>Mizoram</asp:ListItem>
                        <asp:ListItem>Nagaland</asp:ListItem>
                        <asp:ListItem>Odisha</asp:ListItem>
                        <asp:ListItem>Punjab</asp:ListItem>
                        <asp:ListItem>Rajasthan</asp:ListItem>
                        <asp:ListItem>Sikkim</asp:ListItem>
                        <asp:ListItem>Tamilnadu</asp:ListItem>
                        <asp:ListItem>Telengana</asp:ListItem>
                        <asp:ListItem>Tripura</asp:ListItem>
                        <asp:ListItem>Uttar Pradesh</asp:ListItem>
                        <asp:ListItem>Uttarakhand</asp:ListItem>
                        <asp:ListItem>West Bengal</asp:ListItem>
                        <asp:ListItem>Andaman &amp; Nicobar Islands</asp:ListItem>
                        <asp:ListItem>Chandigarh</asp:ListItem>
                        <asp:ListItem>Dadra &amp; Nagar Haveli and Daman &amp; Diu</asp:ListItem>
                        <asp:ListItem>Delhi</asp:ListItem>
                        <asp:ListItem>Jammu and Kashmir</asp:ListItem>
                        <asp:ListItem>Ladakh</asp:ListItem>
                        <asp:ListItem>Lakshadweep</asp:ListItem>
                        <asp:ListItem>Puducherry </asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblPlace" runat="server" Text="Place Name:" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px"></asp:Label>
                    <asp:TextBox ID="txtPlace" runat="server" CssClass="form-control" Placeholder="Place Name"
                        TextMode="MultiLine" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblShort" runat="server" Text="Short Summary:" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px"></asp:Label>
                    <asp:TextBox ID="txtShort" runat="server" CssClass="form-control" Placeholder="Short Summary"
                        TextMode="MultiLine" />
                </div>
            </div>
            <%--Description--%>
            <div class="row">
                <div class="col-12">
                    <asp:Label ID="lblDesc" runat="server" Text="Enter Description :" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px; max-height: 50px;"></asp:Label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Placeholder="Description" />
                </div>
            </div>

            <%--Image--%>
            <div class="row">
                <div class="col-md-11">
                    <asp:Label ID="lblImage" runat="server" Text="Upload the Image :" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px"></asp:Label>
                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                    <asp:HiddenField ID="hfImagePath" runat="server" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddImage" runat="server" OnClientClick="addImage(); return false;" Text="Add" CssClass="btn btn-outline-success" Style="margin-top: 24px" />
                </div>

            </div>
            <div class="row">
                <div class="col-md-4">
                    <div id="imagesContainer" class="mt-2"></div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <h3>Historical and Architectural Background</h3>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <asp:Label ID="lblPeriod" runat="server" Text="Enter the Builder/Period time :" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px; max-height: 50px;"></asp:Label>
                    <asp:TextBox ID="txtPeriod" runat="server" CssClass="form-control" Placeholder="Builder/Period"
                        TextMode="MultiLine" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <h3 class="section-subheader">Location & Settings</h3>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <asp:Label ID="lblLocation" runat="server"
                        Text="Google Map Embed URL :" class="section-subheader"
                        Style="font-weight: bold; font-size: 15px"></asp:Label>

                    <asp:TextBox ID="txtLocation" runat="server"
                        CssClass="form-control"
                        Placeholder="Paste Google Map iframe src URL"
                        TextMode="MultiLine" />
                </div>
                <div class="col-md-6">
                    <asp:Label ID="lblSetting" runat="server" class="section-subheader" Text="Enter the setting :"
                        Style="font-weight: bold; font-size: 15px; max-height: 50px"></asp:Label>
                    <asp:TextBox ID="txtSeting" runat="server" CssClass="form-control" Placeholder="Settings"
                        TextMode="MultiLine" />
                </div>
            </div>
            <%--Architectural State--%>
            <div class="row">
                <div class="col-12">
                    <asp:Label ID="lblStateToday" runat="server" class="section-subheader" Text="Architectural State Today :"
                        Style="font-weight: bold; font-size: 15px"></asp:Label>
                    <asp:TextBox ID="txtState" runat="server" CssClass="form-control"
                        TextMode="MultiLine" Placeholder="Architectural State Today" Style="max-height: 150px; height: 174px" />
                </div>
            </div>

            <%--Haunted Claims--%>
            <div class="row">
                <div class="col-12">
                    <asp:Label ID="lblClaims" runat="server" class="section-subheader" Text="Enter the Haunted Claims :" Style="font-weight: bold; font-size: 15px; max-height: 50px"></asp:Label>
                </div>
            </div>

            <div class="row">
                <div class="col-md-11">
                    <asp:TextBox ID="txtClaims" runat="server" CssClass="form-control" TextMode="MultiLine" PlaceHolder="Haunted Claims" />
                    <asp:HiddenField ID="hfSelectedClaimIndex" runat="server" Value="-1" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddClaims" runat="server" OnClientClick="addClaim(); return false;" Text="Add" CssClass="btn btn-outline-success" Style="margin-top: 12px" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div id="claimsContainer" class="mt-2"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-11">
                    <asp:Label ID="lblYoutube" runat="server" Text="Youtube Links :"
                        Style="font-weight: bold; font-size: 15px" class="section-subheader"></asp:Label>

                    <asp:TextBox ID="txtYoutube" runat="server" CssClass="form-control" TextMode="MultiLine" Placeholder="Give YT Iframe Source link here" />
                </div>
                <div class="col-md-1">
                    <asp:Button ID="btnAddYoutube" runat="server" type="Button" OnClientClick="addYoutube(); return false;" Text="Add" CssClass="btn btn-outline-success" Style="margin-top: 35px;" />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div id="youtubeContainer" class="mt-2"></div>
                </div>
            </div>

            <div>
                <asp:CheckBox ID="chkActive" runat="server" Text="  Is Active" />

                <br />
                <br />

                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-outline-success" OnClick="btnSave_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-info" OnClick="btnClear_Click" />
            </div>
        </div>
    </div>
    <div class="admin-box">
        <h3 class="section-subheader">Added Ghost Places List</h3>

        <asp:GridView ID="gvPlaces" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="PlaceID" ClientIDMode="Static"
            HorizontalAlign="Center" class="table table-striped table-bordered" OnRowCommand="gvPlaces_RowCommand">

            <Columns>
                <asp:BoundField DataField="State" HeaderText="State" />
                <asp:BoundField DataField="PlaceName" HeaderText="Place Name" />
                <asp:BoundField DataField="ShortSummary" HeaderText="Summary" />

                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="action-col">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server"
                            Text="Edit"
                            CssClass="btn btn-warning btn-sm"
                            CommandName="EditRow"
                            CommandArgument='<%# Eval("PlaceId") %>' />

                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CssClass="btn btn-danger btn-sm"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("PlaceId") %>'
                            OnClientClick="return confirm('Are you sure?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>
    <script>

        /*CLAIMS*/

        function addClaim() {
            let value = document.getElementById('<%=txtClaims.ClientID%>').value;
            let index = parseInt(document.getElementById('<%=hfSelectedClaimIndex.ClientID%>').value);

            if (!value) return;

            fetch("AdminPage.aspx/AddClaim", {
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ claim: value, index: index })
            })
                .then(r => r.json())
                .then(d => {
                    renderClaims(d.d);
                    document.getElementById('<%=txtClaims.ClientID%>').value = "";
                document.getElementById('<%=hfSelectedClaimIndex.ClientID%>').value = -1;
            });
        }

        function deleteClaim(i) {
            fetch("AdminPage.aspx/DeleteClaim", {
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            })
                .then(r => r.json())
                .then(d => renderClaims(d.d));
        }
        function selectClaim(index, text) {
            document.getElementById('<%=txtClaims.ClientID%>').value = text;
            document.getElementById('<%=hfSelectedClaimIndex.ClientID%>').value = index;
        }

        function renderClaims(list) {
            let html = "";
            list.forEach((item, i) => {
                html += `
                <div class="border p-2 mb-1 d-flex justify-content-between align-items-center"
                     style="background:black; cursor:pointer;"
                     onclick="selectClaim(${i}, \`${item.replace(/`/g, '\\`')}\`)">

                    <span>${item}</span>

                    <button class="btn btn-sm btn-danger" type="button"
                            onclick="event.stopPropagation(); deleteClaim(${i})">✕</button>
                </div>`;
            });

            document.getElementById("claimsContainer").innerHTML = html;
        }


        /*YOUTUBE*/

        function addYoutube() {
            let value = document.getElementById('<%=txtYoutube.ClientID%>').value;
            if (!value) return;

            fetch("AdminPage.aspx/AddYoutube", {
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ link: value })
            })
                .then(r => r.json())
                .then(d => {
                    renderYoutube(d.d);
                    document.getElementById('<%=txtYoutube.ClientID%>').value = "";
        });
        }

        function deleteYoutube(i) {
            fetch("AdminPage.aspx/DeleteYoutube", {
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            })
                .then(r => r.json())
                .then(d => renderYoutube(d.d));
        }

        function renderYoutube(list) {
            let html = "";
            list.forEach((item, i) => {
                html += `
                <div class="border p-2 mb-1 d-flex justify-content-between align-items-center" style="background-color:black; height:50px; width:900px">
                    <span>${item}</span>
                    <button class="btn btn-sm btn-danger" type="button" onclick="deleteYoutube(${i})">✕</button>
                </div>`;
            });
            document.getElementById("youtubeContainer").innerHTML = html;
        }

        /*IMAGES */

        function addImage() {

            let fileInput = document.getElementById('<%=fuImage.ClientID%>');
            let file = fileInput.files[0];
            if (!file) return;

            let formData = new FormData();
            formData.append("file", file);

            fetch("UploadHandler.ashx", {
                method: "POST",
                body: formData
            })
                .then(r => r.text())
                .then(path => {

                    fetch("AdminPage.aspx/AddImage", {
                        method: "POST",
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ imagePath: path })
                    })
                        .then(r => r.json())
                        .then(d => renderImages(d.d));
                    fileInput.value = "";
                });
        }

        function deleteImage(i) {
            fetch("AdminPage.aspx/DeleteImage", {
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: i })
            })
                .then(r => r.json())
                .then(d => renderImages(d.d));
        }

        function renderImages(list) {
            let html = "";
            list.forEach((path, i) => {
                html += `
                <div style="display:inline-block;position:relative;margin:3px;">
                    <img src="${path}" style="height:80px;border-radius:6px;" />
                    <button onclick="deleteImage(${i})" type="button"
                        style="position:absolute;top:-6px;right:-6px;
                               background:red;color:white;border:none;
                               border-radius:50%;width:22px;height:22px;">✕</button>
                </div>`;
            });
            document.getElementById("imagesContainer").innerHTML = html;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
