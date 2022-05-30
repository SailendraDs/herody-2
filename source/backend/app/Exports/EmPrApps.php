<?php

namespace App\Exports;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\User;
use App\ProjectApps;

class EmPrApps implements FromView
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
        $proofs = ProjectApps::where(['jid' => $this->id])->get();
        
        return view('employer.projects.export_apps', [
            'gigs' => $proofs,
            'id' =>$this->id,
        ]);
    }
}