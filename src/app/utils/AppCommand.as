/*
 * 			case "showErrorBox":
				showErrorBox(true,o.data);
				break;
			case "showSellBox":
				showSellBox(true,o.itemData,o.infoData,o.inst);
				break;
			case "showExchangeBox":
				showExchangeBox(true);
				break;
			case "showExpInfoBox":
				showExpInfoBox(true);
				break;
			case "showAchieveTips":
				showAchieveTips(true);
				break;
			case "showLevelTips":
				showLevelTips(true);
				break;
			case "showSystemTips":
				showSystemTips(true,o.data);
				break;				
			case "showCallingConfirmBox":
				showCallingConfirmBox(true,o.data);
				break;
				
				*/
package app.utils
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	public class AppCommand
	{				
		public static const SHOW_ERROR_BOX:String = "showErrorBox";
		public static const SHOW_SELL_BOX:String = "showSellBox";
		public static const SHOW_EXCHANGE_BOX:String = "showExchangeBox";
		public static const SHOW_EXP_INFO_BOX:String = "showExpInfoBox";
		public static const SHOW_LEVEL_BOX:String = "showLevelTips";
		public static const SHOW_SYSTEM_TIPS_BOX:String = "showSystemTips";
		public static const SHOW_CALLING_CONFIRM_BOX:String = "showCallingConfirmBox";//show it when calling was over
		public static const SHOW_ACHIEVE_TIPS_BOX:String = "showAchieveTips";
		
		
		public static const GetUserInfo:String = "user.GetUserInfo";
		public static const GetAchievementRule:String = "user.GetAchievementRule";
		public static const UpdateUserAchievement:String = "user.updateUserAchievement";
		
		public static const GetAchievement:String = "gs.GetAchievement";		
		public static const GS_BuyFood:String = "gs.BuyFood";
		public static const GS_BuyFromFriend:String = "gs.BuyFromFriend";
		public static const GS_ChangeRoleStatus:String = "gs.ChangeRoleStatus";	
		public static const GS_Decorate:String = "gs.Decorate";
		public static const FeedRole:String = "gs.FeedRole";
		public static const GS_GetDecorateList:String = "gs.GetDecorateList";
		public static const GS_GetDecorateWorkList:String = "gs.GetDecorateWorkList";
		public static const GS_GetFriendList:String = "gs.GetFriendList";
		public static const GS_GetNotRegFriendList:String = "gs.GetNotRegFriendList";
		public static const GS_GetProductionInfo:String = "gs.GetProductionInfo";
		public static const GS_GetResInfoList:String = "gs.GetResInfoList";
		public static const GS_GetRoleFamily:String = "gs.GetRoleFamily";
		public static const GS_GetRoleInfo:String = "gs.GetRoleInfo";
		public static const GS_GetRoleSellList:String = "gs.GetRoleSellList";
		public static const GS_GetRoleWorkList:String = "gs.GetRoleWorkList";
		public static const GS_GetSleepItems:String = "gs.GetSleepItems";
		public static const GS_GetUserFoodList:String = "gs.GetUserFoodList";		
		public static const GS_GetUserMaterialList:String = "gs.GetUserMaterialList";
		public static const GS_GetUserRoleList:String = "gs.GetUserRoleList";
		public static const GS_MemberBuy:String = "gs.MemberBuy";
		public static const GS_ResInfo:String = "gs.ResInfo";
		public static const GS_RoleClick:String = "gs.RoleClick";
		public static const GS_RoleMix:String = "gs.RoleMix";
		public static const GS_RoleSell:String = "gs.RoleSell";
		public static const GS_RoleUpgrading:String = "gs.RoleUpgrading";
		public static const GS_RoleWork:String = "gs.RoleWork";
		public static const GS_SQLAdmin:String = "gs.SQLAdmin";
		public static const GS_SQLAdmin_Update:String = "gs.SQLAdmin_Update";
		public static const GS_SellToSystem:String = "gs.SellToSystem";
		public static const GS_SetXY:String = "gs.SetXY";
		public static const GS_SetXY2:String = "gs.SetXY2";
		public static const GS_UpdateResContent:String = "gs.UpdateResContent";
		public static const GS_UpdateResNickName:String = "gs.UpdateResNickName";
		public static const GS_UserMoney:String = "gs.UserMoney";
		public static const GS_UserShopping:String = "gs.UserShopping";
		public static const GS_UserShoppingtwo:String = "gs.UserShoppingtwo";
		
		public static const MSG_GetMsg:String = "msg.GetMsg";
		public static const MSG_DelMsg:String = "msg.DelMsg";
		public static const MSG_SendMsg:String = "msg.SendMsg";
		
		public static const FRIEND_BuyRoleFromFriends:String = "friend.BuyRoleFromFriends";
		public static const FRIEND_GetFriendList:String = "friend.GetFriendList";
		
		public static const CheckFriendStatus:String = "gs.CheckFriendStatus";
		
		public static const GIFT_sendUserGift:String = "gift.sendUserGift";
		public static const GIFT_sendNewGift:String = "gift.sendNewGift";
		
		public static const UpdateIntroStatus:String = "intro.UpdateIntroStatus";

		public function AppCommand()
		{
			
		}	
	}
}