<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\User;

class AllUsers implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function view():View
    {
        $users = User::get();
        
        return view('admin.exports.allusers', [
            'users' => $users,
        ]);
    }
}
