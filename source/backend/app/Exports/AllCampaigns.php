<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\Campaign;

class AllCampaigns implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function view():View
    {
        $campaigns = Campaign::get();
        
        return view('admin.exports.allcampaigns', [
            'campaigns' => $campaigns,
        ]);
    }
}
