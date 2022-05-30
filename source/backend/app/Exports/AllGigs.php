<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\Gig;

class AllGigs implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function view():View
    {
        $gigs = Gig::get();
        
        return view('admin.exports.allgigs', [
            'gigs' => $gigs,
        ]);
    }
}
