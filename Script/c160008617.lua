--SPC Recharge
function c160008617.initial_effect(c)
c:EnableCounterPermit(0x88)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,160008617+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c160008617.target)
	e1:SetOperation(c160008617.activate)
	c:RegisterEffect(e1)
end
function c160008617.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x11a) and c:IsCanAddCounter(0x88,1)
end
function c160008617.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c160008617.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160008617.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(160008617,1))
	Duel.SelectTarget(tp,c160008617.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x88)
end

function c160008617.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x88,1) then
		end
	end
