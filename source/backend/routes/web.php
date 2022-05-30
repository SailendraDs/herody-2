<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    $cats = [
        "SALES & BUSINESS DEVELOPMENT",
        "PRODUCTION",
        "MAINTENANCE",
        "ACCOUNTING AND FINANCE",
        "ADMIN & HUMAN RESAURCES (HR) MANAGEMENT",
        "PROCUREMENT & PLANNING",
        "TESTING & QUALITY",
        "RESEARCH & DEVELOPMENT (R & D)",
        "DESIGN",
        "MARKETING",
        "TRAINING & DEVELOPMENT",
        "PURCHASING",
        "SUPPLY CHAIN MANAGEMENT",
        "INVENTORY & STORE",
        "IT & ITES",
        "ENVIRONMENTAL HEALTH AND SAFETY",
        "CORPORATE SUPPORT",
        "ENGINEERING",
        "ELECTRICAL",
        "MECHANICAL",
        "FACILITY MANAGEMENT",
        "CUSTOMER SERVICE SUPPORT",
        "CONSULTANT",
        "EXPERT",
        "CONTRACTOR",
        "OTHER",
    ];
    $works = App\Work::all()->take(6);
    return view('welcome')->with([
        'works' => $works,
        'cats' => $cats,
    ]);
})->name("index");
Route::get('privacy-policy',function(){
    return view('privacy-policy');
})->name('privacy-policy');
Route::get('user/email-verified/{id}','User\DashboardController@email_verified');
// Admin
Route::get('admin','Admin\HomeController@index')->name('admin');
Route::post('admin','Admin\HomeController@login')->name('admin');

Route::middleware(['Admin.Auth'])->prefix('admin')->namespace('Admin')->name('admin.')->group(function () {
    // Managers
    Route::get('managers','ManagerController@index')->name('managers');
    Route::post('create','ManagerController@create')->name('manager.create');
    Route::post('storeForm','ManagerController@storeForm')->name('manager.storeForm');
    Route::post('delete','ManagerController@delete')->name('manager.delete');

    // Dashboard
    Route::get('dashboard','DashboardController@dashboard')->name('dashboard');
    Route::get('change-password','HomeController@changePassword')->name('changePassword');
    Route::post('change-password','HomeController@PasswordUpdate')->name('changePassword');
    Route::post('logout','HomeController@logout')->name('logout');

    //Projects
    Route::get('pending-works', 'WorkController@pending')->name('work.pending');
    Route::get('all-works', 'WorkController@all')->name('work.all');
    Route::post('approve-project', 'WorkController@approve')->name('work.approve');
    Route::post('delete-project', 'WorkController@delete')->name('work.delete');

    //member manage
    Route::get('member', 'MemberManageController@ShowAllMember')->name('member.all');
    Route::get('pending-regs', 'MemberManageController@pending')->name('member.pending');
    Route::get('pending-regs/approve/{id}', 'MemberManageController@approve')->name('member.approve');
    Route::get('pending-regs/reject/{id}', 'MemberManageController@reject')->name('member.reject');
    Route::get('member/{id}', 'MemberManageController@ShowMemberDetails')->name('member.details');
    Route::post('member-update', 'MemberManageController@MemberUpdate')->name('member.update');
    Route::get('member/export/excel', 'MemberManageController@excel_export')->name('member.export');
    Route::get('member/export/referrals', 'MemberManageController@excel_referrals')->name('member.export.referrals');

    //Withdraw methods
    Route::get('withdrawals/pending', 'WithdrawalController@pending')->name('withdrawals.pending');
    Route::post('withdrawals/accept', 'WithdrawalController@accept')->name('withdrawals.accept');
    Route::post('withdrawals/reject', 'WithdrawalController@reject')->name('withdrawals.reject');
    Route::get('withdrawals/approved', 'WithdrawalController@approved')->name('withdrawals.approved');

    // Excel Exports
    Route::get('work/export','WorkController@export_excel')->name('work.export');
    Route::get('withdraw/export','WithdrawalController@export_excel')->name('withdraw.export');

    // Employers
    Route::get('employers','EmployerController@index')->name('employers');
    Route::post('employer/login','EmployerController@login')->name('employer.login');

    // Chats
    Route::get('chats','ChatController@index')->name('chats');
    Route::post('chats/assign','ChatController@assign')->name('chats.assign');
    Route::get('messages/{type}/{id}','ChatController@messages')->name('messages');
    Route::post('sendMessage','ChatController@sendMessage')->name('sendMessage');

    // Support
    Route::get('supports','SupportController@index')->name('supports');
    Route::post('supports/delete','SupportController@delete')->name('supports.delete');

    // Join Team
    Route::get('join-team/page','JoinTeamController@index')->name('join-team.page');
    Route::post('join-team/page','JoinTeamController@page')->name('join-team.page');
    Route::get('join-team/categories','JoinTeamController@categories')->name('join-team.categories');
    Route::post('join-team/categories','JoinTeamController@category')->name('join-team.categories');
    Route::post('join-team/categories/delete','JoinTeamController@categoryDelete')->name('join-team.categories.delete');
    Route::get('join-team/forms','JoinTeamController@forms')->name('join-team.forms');
    Route::post('join-team/forms/delete','JoinTeamController@formsDelete')->name('join-team.forms.delete');

    // Custom Project
    Route::get('custom-project/page','CustomProjectController@index')->name('custom-project.page');
    Route::post('custom-project/page','CustomProjectController@page')->name('custom-project.page');
    Route::get('custom-project/categories','CustomProjectController@categories')->name('custom-project.categories');
    Route::post('custom-project/categories','CustomProjectController@category')->name('custom-project.categories');
    Route::post('custom-project/categories/delete','CustomProjectController@categoryDelete')->name('custom-project.categories.delete');
    Route::get('custom-project/forms','CustomProjectController@forms')->name('custom-project.forms');
    Route::post('custom-project/forms/delete','CustomProjectController@formsDelete')->name('custom-project.forms.delete');
});

// Manager
Route::get('manager','Manager\HomeController@index')->name('manager');
Route::post('manager','Manager\HomeController@login')->name('manager');
Route::middleware(['Manager'])->prefix('manager')->namespace('Manager')->name('manager.')->group(function () {
    // Dashboard
    Route::get('dashboard','DashboardController@dashboard')->name('dashboard');
    Route::get('change-password','HomeController@changePassword')->name('changePassword');
    Route::post('change-password','HomeController@PasswordUpdate')->name('changePassword');
    Route::post('logout','HomeController@logout')->name('logout');

    //Projects
    Route::get('pending-works', 'WorkController@pending')->name('work.pending');
    Route::get('all-works', 'WorkController@all')->name('work.all');
    Route::post('approve-project', 'WorkController@approve')->name('work.approve');
    Route::post('delete-project', 'WorkController@delete')->name('work.delete');

    //member manage
    Route::get('member', 'MemberManageController@ShowAllMember')->name('member.all');
    Route::get('pending-regs', 'MemberManageController@pending')->name('member.pending');
    Route::get('pending-regs/approve/{id}', 'MemberManageController@approve')->name('member.approve');
    Route::get('pending-regs/reject/{id}', 'MemberManageController@reject')->name('member.reject');
    Route::get('member/{id}', 'MemberManageController@ShowMemberDetails')->name('member.details');
    Route::post('member-update', 'MemberManageController@MemberUpdate')->name('member.update');
    Route::get('member/export/excel', 'MemberManageController@excel_export')->name('member.export');
    Route::get('member/export/referrals', 'MemberManageController@excel_referrals')->name('member.export.referrals');

    //Withdraw methods
    Route::get('withdrawals/pending', 'WithdrawalController@pending')->name('withdrawals.pending');
    Route::post('withdrawals/accept', 'WithdrawalController@accept')->name('withdrawals.accept');
    Route::post('withdrawals/reject', 'WithdrawalController@reject')->name('withdrawals.reject');
    Route::get('withdrawals/approved', 'WithdrawalController@approved')->name('withdrawals.approved');

    // Excel Exports
    Route::get('work/export','WorkController@export_excel')->name('work.export');
    Route::get('withdraw/export','WithdrawalController@export_excel')->name('withdraw.export');

    // Employers
    Route::get('employers','EmployerController@index')->name('employers');
    Route::post('employer/login','EmployerController@login')->name('employer.login');

    // Chats
    Route::get('chats','ChatController@index')->name('chats');
    Route::post('chats/solve','ChatController@solve')->name('chats.solve');
    Route::post('chats/close','ChatController@close')->name('chats.close');
    Route::get('messages/{type}/{id}','ChatController@messages')->name('messages');
    Route::post('sendMessage','ChatController@sendMessage')->name('sendMessage');

    // Support
    Route::get('supports','SupportController@index')->name('supports');
    Route::post('supports/delete','SupportController@delete')->name('supports.delete');
});


Auth::routes(['verify' => true]);
Route::get('/home', 'HomeController@index')->name('home');

// Non-authenticated Employer
Route::get('for-businesses','Employer\HomeController@to_register')->name('employer.for-businesses');
Route::post('for-businesses','Employer\HomeController@register')->name('employer.register');
Route::get('business/login','Employer\HomeController@to_login')->name('employer.login');
Route::get('company/verify-email','Employer\HomeController@resendemail')->name('employer.verify.email')->middleware(['employerAuth']);
Route::post('company/verify-email','Employer\HomeController@brand')->name('employer.verify.emailr')->middleware(['employerAuth']);
Route::get('company/brand','Employer\DashboardController@brand')->name('employer.brand')->middleware(['employerAuth','empEmail']);
Route::post('company/brand','Employer\DashboardController@savecompany')->name('employer.save.company')->middleware(['employerAuth','empEmail']);
Route::post('business/login','Employer\HomeController@login')->name('employer.login');
Route::get('company/logout','Employer\HomeController@logout')->name('employer.logout')->middleware(['employerAuth']);

// Truecaller
Route::post('truecaller','TrueCallerController@login')->name('truecaller.login');

//World Controller
Route::post('/getstates','WorldController@states')->name('world.states');
Route::post('getcities','WorldController@cities')->name('world.cities');

// Employer
Route::middleware(['employerAuth','empEmail','BrandCheck'])->namespace('Employer')->prefix('company')->name('employer.')->group(function(){
    Route::get('dashboard','DashboardController@dashboard')->name('dashboard');
    Route::get('profile','DashboardController@profile')->name('profile');
    Route::post('profile','DashboardController@update_profile')->name('profile');
    Route::post('profile-image','DashboardController@upload_profile_image')->name('profile_image.update');
    Route::get('change-pass','DashboardController@change_passr')->name('changepass');
    Route::post('change-pass','DashboardController@change_pass')->name('changepass');
    
    Route::get('works','WorkController@index')->name('work.manage');
    Route::get('works/post','WorkController@create')->name('work.post');
    Route::post('works/post','WorkController@store')->name('work.post');
    Route::post('works/delete','WorkController@delete')->name('work.delete');
    Route::get('works/edit/{id}','WorkController@edit')->name('work.edit');
    Route::post('works/edit/{id}','WorkController@update')->name('work.edit');
    Route::get('works/applications/{id}','WorkController@applications')->name('work.applications');
    Route::post('works/shortlist/{id}','WorkController@shortlist')->name('work.shortlist');
    Route::post('works/select/{id}','WorkController@select')->name('work.select');
    Route::post('works/reject/{id}','WorkController@reject')->name('work.reject');
    Route::get('works/files/{id}','WorkController@files')->name('work.files');
    Route::post('works/accept','WorkController@accept')->name('work.accept');
    
    Route::get('wallet','WalletController@index')->name('wallet');
    Route::post('wallet/add','WalletController@addMoney')->name('wallet.add');
    Route::post('wallet/add/done/{amount}','WalletController@doneMoney')->name('wallet.add.done');

    // Chats
    Route::get('chats','ChatController@index')->name('chats');
    Route::get('messages/{type}/{id}','ChatController@messages')->name('messages');
    Route::get('support','ChatController@support')->name('support');
    Route::post('sendMessage','ChatController@sendMessage')->name('sendMessage');
});
Route::get('employer/email-not-verified',function(){
    return view('employer.pages.text_email_verify');
})->name('employer.email.verify');

// Project
Route::get('works','WorkController@list')->name('works');
Route::get('work/{id}/{name}','WorkController@details')->name('work.details');
Route::post('work/category','WorkController@cat')->name('work.cat');
Route::middleware(["auth"])->group(function(){
    Route::post('work/apply','WorkController@apply')->name('work.apply');
});

// Applicant View
Route::get('users/{id}','JobController@selecteds')->name('applicant.view');
Route::get('users/{id}/print','JobController@selecteds')->name('print.view');


// Users
Route::get('user/mobile-not-verified','User\DashboardController@mobileNotVerified')->name('user.mobile-not-ver')->middleware(['auth','verified']);
Route::get('user/verify-mobile','User\DashboardController@verifyMobiler')->name('user.verify-mobile')->middleware(['auth','verified']);
Route::post('user/verify-mobile','User\DashboardController@verifyMobile')->name('user.verify-mobilep')->middleware(['auth','verified']);
Route::middleware(['auth','verified'])->namespace('User')->prefix('user')->name('user.')->group(function(){
    Route::get('app-download','DashboardController@download')->name('download_app');
    Route::get('dashboard','DashboardController@dashboard')->name('dashboard');
    Route::get('resume','DashboardController@resume')->name('resume');
    Route::post('edu-update','DashboardController@eduUpdate')->name('edu-update');
    Route::post('exp-update','DashboardController@expUpdate')->name('exp-update');
    Route::post('proj-update','DashboardController@projUpdate')->name('proj-update');
    Route::post('skill-update','DashboardController@skillUpdate')->name('skill-update');
    Route::post('hobby-update','DashboardController@hobbyUpdate')->name('hobby-update');
    Route::post('ach-update','DashboardController@achUpdate')->name('ach-update');
    Route::post('social-update','DashboardController@socialUpdate')->name('social-update');
    Route::get('edu-delete/{id}','DashboardController@eduDelete')->name('edu-delete');
    Route::get('exp-delete/{id}','DashboardController@expDelete')->name('exp-delete');
    Route::get('proj-delete/{id}','DashboardController@projDelete')->name('proj-delete');
    Route::get('skill-delete/{id}','DashboardController@skillDelete')->name('skill-delete');
    Route::get('profile','DashboardController@profile')->name('profile');
    Route::post('profile','DashboardController@updateProfile')->name('profile');
    Route::get('change-pass','DashboardController@changepwr')->name('changePassword');
    Route::post('change-pass','DashboardController@updatePassword')->name('changePassword');
    Route::get('logout','DashboardController@logout')->name('logout');

    // Wallet
    Route::get('wallet','WalletController@index')->name('wallet');
    Route::get('wallet/accounts','WalletController@accounts')->name('wallet.accounts');
    Route::post('wallet/withdraw','WalletController@withdraw')->name('wallet.withdraw');
    Route::post('wallet/accounts/bank','WalletController@addBank')->name('wallet.addBank');
    Route::post('wallet/accounts/upi','WalletController@addUpi')->name('wallet.addUpi');

    // Works
    Route::get('works','WorkController@works')->name('works.show');
    Route::get('works/work/{id}','WorkController@work')->name('works.work');
    Route::post('works/work/{id}/whole','WorkController@whole')->name('works.work.whole');
    Route::post('works/work/{id}/objective','WorkController@objective')->name('works.work.objective');

    // Chats
    Route::get('chats','ChatController@index')->name('chats');
    Route::get('messages/{type}/{id}','ChatController@messages')->name('messages');
    Route::get('support','ChatController@support')->name('support');
    Route::post('sendMessage','ChatController@sendMessage')->name('sendMessage');
});

//User View
Route::post('acc_details',"RazorpayController@create_contact");
Route::get('users/{id}','ApplicantController@index')->name('applicant.view');
Route::get('users/{id}/print-resume','ApplicantController@printv')->name('print.view');
Route::get('users/{id}/print-pdf','ApplicantController@print')->name('print.pdf');

//Certificate Controller
Route::get('certificate/{jid}/user/{uid}/view','ApplicantController@printc')->name('certificate.print');

// Join Team
Route::get('join-team','JoinTeamController@index')->name('join-team');
Route::post('join-team','JoinTeamController@form')->name('join-team');

// Custom Project
Route::get('custom-project','CustomProjectController@index')->name('custom-project');
Route::post('custom-project','CustomProjectController@form')->name('custom-project');

// TEST
// Route::get('test','TestController@test');