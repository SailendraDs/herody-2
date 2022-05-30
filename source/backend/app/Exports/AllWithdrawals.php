<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\Withdraw;

class AllWithdrawals implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function view():View
    {
        $wrs = Withdraw::get();
        
        return view('admin.exports.allwithdraws', [
            'wrs' => $wrs,
        ]);
    }
}
