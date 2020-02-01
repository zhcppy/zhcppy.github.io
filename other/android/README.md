# Android

## 构建APK脚本

[android_build_apk](android_build_apk.sh ':include :type=code bash')

## 通过adb更新应用外部依赖

[android_update_file](android_update_file.sh ':include :type=code bash')

## 转场动画

> **相关项目[imemory](https://github.com/zhcppy/imemory)**

转场动画即在Activity之间切换时执行的动画，是为了提高用户体验的整体美感

* 简单转场动画

启动Activity的方法

    Intent intent = new Intent(context, LoginActivity.class);
    context.startActivity(intent, ActivityOptions.makeSceneTransitionAnimation((Activity) context).toBundle());

这里就改变了一个地方，之前startActivity方法是只需要专递intent就可以，现在就是在startActivity方法增加了一个参数，使用转场动画启动下一个Activity。

在onCreate方法中添加下面两句话，第一句是设置启动时动画运行的时间，第二句是退出时动画运行的时间，单位都是毫秒，我们的应用一般都会有个BaseActivity，可以将这两句话加在BaseActivity中，可以避免在每个Activity中添加。

	@Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        getWindow().setEnterTransition(new Explode().setDuration(500));
        getWindow().setExitTransition(new Explode().setDuration(500));
        super.onCreate(savedInstanceState);
    }

最后还需要修改主题样式，在对应Activity使用的主题上设置下面属性

	<item name="android:windowContentTransitions">true</item>

这样最简单的转场动画就实现了

* 炫酷转场动画

要想实现更加炫酷的转场动画就需要在启动下一个Activity之前做更多的准备了

makeSceneTransitionAnimation方法其实还可以传递参数，不信你安装Ctrl进去看看，后面传递的是一个可变长参数（暂且把它理解成数组），这个参数就是来设置Activity跳转之间的共享元素的，具体方法为

首先需要在xml中给共享的View都设置相同的标识

	android:transitionName="btn_logo_register"

然后修改Activity启动

	Intent intent = new Intent(context, LoginActivity.class);
    context.startActivity(intent, 
		ActivityOptions.makeSceneTransitionAnimation((Activity) context, 
		Pair.create(((View)mLoginBtn), "btn_logo_register")).toBundle());

然后你会发现设置了相同transitionName属性的两个View在Activity之间跳转是有了那么一缕联系

更多炫酷的动画就是要巧妙的设计共享元素这个参数了

* 坑(问题)

&emsp;&emsp;在使用了转场动画去启动下一个Activity后，执行finish()方法关闭Activity回退时，发现Activity是退回来了，但是屏幕始终都无法点击（当时我还以为我手机坏了呢），手机上的实体键和虚拟键都还能用。后来我又发现使用手机上的虚拟键回退Activity时，屏幕是能点击，然后我就研究了下onBackPressed()这个方法，因为点击手机上的虚拟键时是调用这个方法结束Activity的，在onBackPressed()方法里执行了finishAfterTransition()这样一个方法，我看到这个方法的名字就明白了，大概就是说在执行完转场后finish嘛，所以在使用转场动画的方启动Activity时手动结束Activity要使用finishAfterTransition()。

尽管finishAfterTransition()最后还是调用了finish()方法。毕竟在执行之前做了判断啊

* android中Activity重建后Fragment重复创建

今天写项目遇到一个问题，就是一个Activity里面有多个Fragment需要管理，当屏幕旋转时多个Fragment会出现重叠的现象，原因是因为旋转屏幕时Activity会重建，造成Fragment多次创建产生重叠。

其实这个问题一句话也是可以解决的，就是在Android项目的配置文件中给相应的Activity加上   

    android:configChanges="orientation|screenSize|keyboardHidden"

这句话的意思就是让Activity不要重建，屏幕旋转的问题解决，但是···

但是如果就这样的解决问题，那我今天就将它不会记录下来了，因为Activity重建不只是在屏幕发生旋转时才会有的，其他情况也是有可能的，比如：**应用退到后台了**、**突然来了个电话**（也是退到后台了），像这样的情况我不知道上面那句话行不行，但是就是因为这个才引发我的思考，还能不能有其他的方法呢。

在Activity发生重建之前，保存当前的数据，在Activity再次创建时恢复

1.首先是保存Activity销毁之前的数据

	@Override  
	protected void onSaveInstanceState(Bundle outState) {  
	    outState.putInt("current",currentFragment);  
	    super.onSaveInstanceState(outState);  
	} 

2.重写onSaveInstanceState方法，将当先显示的是第几个Fragment用outState保存起来。
然后在onCreate方法里做还原操作

	@Override
    protected void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	setContentView(R.layout.activity_main);
    	fragmentManager = getFragmentManager();
       	// 从savedInstanceState中恢复数据, 如果没有数据需要恢复savedInstanceState为null
       	if (savedInstanceState != null) {
        //当Activity发生重建时还原Fragment
        mMyLifeFragment = (MyLifeFragment) fragmentManager.findFragmentByTag("MyLifeFragment");
        mFindFragment = (FindFragment) fragmentManager.findFragmentByTag("FindFragment");
        mMessageFragment = (MessageFragment) fragmentManager.findFragmentByTag("MessageFragment");
        if(mMessageFragment!=null){
            fragmentManager.beginTransaction().hide(mMessageFragment).commit();
        }
        if (mFindFragment!=null){
            fragmentManager.beginTransaction().hide(mFindFragment).commit();
        }
        if(mMyLifeFragment!=null){
            //说明Activity发生了重建，设置之前保存的currentFragment
            fragmentManager.beginTransaction().hide(mMyLifeFragment).commit();
            addOrShowFragment(savedInstanceState.getInt("current"));
        }
       }else{
           //没有数据可以还原，初始化主显示界面
           addOrShowFragment(SHOW_LIFE);
       }
   	}


&emsp;&emsp;上面的mMyLifeFragment、mFindfragment、mMessageFragment这三个Fragment是我要在Activity中显示的，addOrShowFragment方法就是用来向FragmentManager添加Fragment或显示FragmentManager里面的Fragment，里面传递的参数就是要显示的是第一个Fragment。

这样实现了即使Activity重建也不会影响显示了。
