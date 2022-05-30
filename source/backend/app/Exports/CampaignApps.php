<?php

namespace App\Exports;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\User;
use App\CampaignApp;

class CampaignApps implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function __construct(int $id)
    {
        $this->id = $id;
        return $this;
    }
    public function view():View
    {
        $proofs = CampaignApp::where(['cid' => $this->id])->get();
        
        return view('admin.exports.campaignapps', [
            'gigs' => $proofs,
            'id' =>$this->id,
        ]);
    }
}
