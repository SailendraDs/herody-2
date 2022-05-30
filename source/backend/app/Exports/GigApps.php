<?php

namespace App\Exports;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\User;
use App\GigApp;

class GigApps implements FromView
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
        $proofs = GigApp::where(['cid' => $this->id])->get();
        
        return view('admin.exports.gigapps', [
            'gigs' => $proofs,
            'id' =>$this->id,
        ]);
    }
}
