function c405105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(405105,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c405105.rmcon)
	e2:SetTarget(c405105.rmtg)
	e2:SetOperation(c405105.rmop)
	c:RegisterEffect(e2)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e2:SetLabelObject(sg)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(405105,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c405105.spcon)
	e3:SetTarget(c405105.sptg)
	e3:SetCountLimit(1,405105)
	e3:SetOperation(c405105.spop)
	e3:SetLabelObject(sg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c405105.atkup)
	c:RegisterEffect(e4)
end
function c405105.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:GetSummonPlayer()==tp
end
function c405105.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c405105.cfilter,1,nil,tp)
end
function c405105.rmfilter(c)
	return c:IsSetCard(0x55) or c:IsSetCard(0x7b) and c:IsAbleToRemove()
end
function c405105.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c405105.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c405105.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c405105.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c405105.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			local sg=e:GetLabelObject()
			if c:GetFlagEffect(405105)==0 then
				sg:Clear()
				c:RegisterFlagEffect(405105,RESET_EVENT+0x1680000,0,1)
			end
			sg:AddCard(tc)
			tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
		end
	end
end
function c405105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetFlagEffect(405105)~=0
end
function c405105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c405105.spfilter(c,rc,e,tp)
	return c:IsRelateToCard(rc) and c:IsAbleToHand()
end
function c405105.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,c405105.spfilter,1,3,nil,e:GetHandler(),e,tp)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c405105.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x55) or c:IsSetCard(0x7b)
end
function c405105.atkup(e,c)
	return Duel.GetMatchingGroupCount(c405105.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*100
end