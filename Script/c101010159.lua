--created & coded by Lyris
--「S・VINE」ベイブ
function c101010159.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c101010159.drcon)
	e1:SetTarget(c101010159.drtg)
	e1:SetOperation(c101010159.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010159)
	e2:SetCondition(c101010159.con)
	e2:SetTarget(c101010159.cost)
	e2:SetOperation(c101010159.op)
	c:RegisterEffect(e2)
end
function c101010159.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e)
end
function c101010159.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(c101010159.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c101010159.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil)>2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)
end
function c101010159.filter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsSetCard(0x785a) and c:IsType(TYPE_MONSTER)
end
function c101010159.op(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetDecktopGroup(tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c101010159.filter,nil)
	if ct==0 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c101010159.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and c:IsFaceup()
end
function c101010159.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c101010159.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(101010159,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
