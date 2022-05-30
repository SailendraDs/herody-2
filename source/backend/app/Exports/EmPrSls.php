<?php

namespace App\Exports;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\User;
use App\Shortlisted;

class EmPrSls implements FromView
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
        $proofs = Shortlisted ::where(['jid' => $this->id])->get();
        
        return view('employer.projects.export_sls', [
            'gigs' => $proofs,
            'id' =>$this->id,
        ]);
    }
}