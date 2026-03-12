<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AdminCards.aspx.cs" Inherits="ghost_series.AdminCards" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .nothing{
            display: flex;
            justify-content:space-around;
            align-items:center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="nothing">
        <div class="card" style="width: 18rem;">
            <img src="images/ghostplaces.png" class="card-img-top" alt="images/ghost.png" style="height: 350px">
            <div class="card-body">
                <h5 class="card-title">State Wise Data</h5>
                <p class="card-text">Haunted Places</p>
                <a href="AdminPage.aspx" class="btn btn-primary">ADD DATA</a>
            </div>
        </div>
        <div class="card" style="width: 18rem;">
            <img src="images/urbanlegend.jfif" class="card-img-top" alt="images/ghost.png">
            <div class="card-body">
                <h5 class="card-title">Card title</h5>
                <p class="card-text">Urban Legends</p>
                <a href="AdminUrbanLegend.aspx" class="btn btn-primary">ADD DATA</a>
            </div>
        </div>
    </div>

</asp:Content>
