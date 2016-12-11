--created & coded by Lyris
--Bladewing Brynhildr
function c101010364.initial_effect(c)
c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbb2),4,2)
	--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--This card gains 200 ATK for each Xyz Material attached to this card and each other "Blademaster" monster you control.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c101010364.val)
	c:RegisterEffect(e1)
	--During your Battle Phase, if your opponent activates a card or effect: You can detach 1 Xyz Material from this card; this card can make a second attack during each Battle Phase this turn, but any battle damage your opponent takes for the rest of the turn becomes halved, also, negate the activation, and if you do, destroy it.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010364,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010364.discon)
	e2:SetCost(c101010364.cost)
	e2:SetTarget(c101010364.distg)
	e2:SetOperation(c101010364.disop)
	c:RegisterEffect(e2)
end
function c101010364.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c101010364.val(e)
	return (e:GetHandler():GetOverlayCount()+Duel.GetMatchingGroupCount(c101010364.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler()))*200
end
function c101010364.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and Duel.GetTurnPlayer()==tp
		and bit.band(Duel.GetCurrentPhase(),0x38)~=0 and Duel.IsChainNegatable(ev)
end
function c101010364.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101010364.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010364.filter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c101010364.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c101010364.dval)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local tc=re:GetHandler()
	Duel.NegateActivation(ev)
	if tc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101010364.dval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return math.floor(dam/2)
	else return dam end
end
