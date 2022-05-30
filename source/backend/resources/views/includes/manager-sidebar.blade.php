<div class="vertical-nav" id="sidebar" style="margin-top:6em;">
	<div class="dashbord_nav_list">
		<ul>
			<li class="{{Request::is('manager/dashboard')? 'active':''}}"><a href="{{route('manager.dashboard')}}"><span class="flaticon-dashboard"></span> Dashboard</a></li>
			<li class="{{Request::is('manager/pending-projects')? 'active':''}}"><a href="{{route('manager.pendingjobs')}}"><span class="flaticon-paper-plane"></span> Pending Internships</a></li>
			<li class="{{Request::is('manager/all-projects')? 'active':''}}"><a href="{{route('manager.jobs.all')}}"><span class="flaticon-paper-plane"></span> All Internships</a></li>
			<li class="{{Request::is('manager/pending-gigs')? 'active':''}}"><a href="{{route('manager.gigs.pending')}}"><span class="flaticon-favorites"></span> Pending Gigs</a></li>
			<li class="{{Request::is('manager/all-gigs')? 'active':''}}"><a href="{{route('manager.gigs.all')}}"><span class="flaticon-chat"></span> All Gigs</a></li>
			<li class="{{Request::is('manager/create-gigs')? 'active':''}}"><a href="{{route('manager.gigs.create')}}"><span class="flaticon-chat"></span> Create Gigs</a></li>
			<li class="{{Request::is('manager/employers')? 'active':''}}"><a href="{{route('manager.employers')}}"><span class="fa fa-user"></span> Employers</a></li>
			<li><a href="{{route('manager.member.export')}}"><span class="fa fa-user"></span> Export all users</a></li>
			<li><a href="{{route('manager.member.export.referrals')}}"><span class="fa fa-user"></span> Export all referrals</a></li>
			<li><a href="{{route('manager.logout')}}"><span class="flaticon-logout"></span> Logout</a></li>
		</ul>
	</div>
</div>