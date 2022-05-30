<?php

namespace App\Exports;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\User;
use App\JobProof;
use App\Project;

class ProjectProofs implements FromView
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
        $proofs = JobProof::where(['jid' => $this->id])->get();
        
        return view('employer.projects.allproofs', [
            'proofs' => $proofs,
            'id' =>$this->id,
        ]);
    }
}
