using Microsoft.AspNetCore.Mvc;
using MyPetClinic.Domain.Entities;
using MyPetClinic.Infrastructure.Persistence;
using System.Threading.Tasks;

namespace MyPetClinic.Controllers
{
    public class AccountController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AccountController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(string username, string email, string password)
        {
            if (ModelState.IsValid)
            {
                var user = new User
                {
                    Username = username,
                    Email = email,
                    PasswordHash = password // Note: In a real application, you MUST hash the password!
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Đăng ký thành công! Dữ liệu đã được lưu vào Supabase.";
                return RedirectToAction("Register");
            }

            return View();
        }
    }
}
