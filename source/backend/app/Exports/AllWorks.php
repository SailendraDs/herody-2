<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\Work;

class AllWorks implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function view():View
    {
        $works = Work::get();
        
        return view('admin.exports.allworks', [
            'works' => $works,
        ]);
    }
}
