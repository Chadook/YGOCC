--created & coded by Lyris
--S・VINEの姫オサ
function c101010431.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010431.cost)
	ae1:SetTarget(c101010431.target)
	ae1:SetOperation(c101010431.op)
	c:RegisterEffect(ae1)
	if not c101010431.global_check then
		c101010431.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010431.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010431.spatial=true
c101010431.dimensional_number_o=4
c101010431.dimensional_number=c101010431.dimensional_number_o
function c101010431.material(mc)
	return mc:IsAttribute(ATTRIBUTE_WATER)
end
function c101010431.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
function c101010431.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and Duel.IsExistingTarget(c101010431.filter,tp,LOCATION_REMOVED,0,3,c)
end
function c101010431.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToGrave()
end
function c101010431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101010431.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010431.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c101010431.cfilter,tp,LOCATION_REMOVED,0,1,nil,tp)
	end
	local g=Duel.SelectMatchingCard(tp,c101010431.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010238,0))
	local g=Duel.SelectTarget(tp,c101010431.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101010431.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct==g:GetCount() then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
