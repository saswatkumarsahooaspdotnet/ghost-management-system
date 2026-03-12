using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace ghost_series
{
    /// <summary>
    /// Summary description for UploadHandler
    /// </summary>
    public class UploadHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            var file = context.Request.Files[0];

            string folder = context.Server.MapPath("~/GMSImages/");
            string fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            string fullPath = System.IO.Path.Combine(folder, fileName);
            file.SaveAs(fullPath);

            context.Response.Write("/GMSImages/" + fileName);
        }

        public bool IsReusable => false;
    }
}